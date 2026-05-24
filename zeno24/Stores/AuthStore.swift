import Foundation
import SwiftUI

/// Single source of truth for the entire auth flow.
///
/// Mirrors the combined behavior of Flutter's `authNotifier` + `signStep1Provider` +
/// `signStep2Provider` + `signStep3Provider`. Keeping them in one observable store
/// avoids the cross-provider read/write coordination that the Riverpod code does.
@MainActor
@Observable
final class AuthStore {
    // MARK: - Root state (drives RootView)
    var state: AuthState = .loading

    // MARK: - Auth NavigationStack path
    /// Routes pushed on top of `SignView` so the OS handles the native
    /// Cupertino push transition. Mutate via `pushAuthRoute(_:)` etc.
    var authPath = NavigationPath()

    // MARK: - Contact entry
    var contactMode: AuthContactMode = .email
    var phoneNumber: String = ""
    var selectedCountry: Country = CountriesData.byCode("AZ") ?? CountriesData.all[0]
    var email: String = ""

    /// Display value shown on the OTP screen ("+994 70 383 12 34" or
    /// masked email "fidan******@gmail.com" — `maskedContactDisplay`).
    var contactDisplay: String = ""

    /// The channel used by step 1 so the OTP screen can switch between
    /// "Code sent to WhatsApp" (phone) and "Enter the code sent to" (email).
    var lastOtpChannel: AuthContactMode = .email

    // MARK: - OTP entry
    var otpCode: String = ""
    var otpHash: String?
    var otpResendNonce: Int = 0    // Bump to restart the timer.
    var showOtpError: Bool = false

    // MARK: - Create name
    var displayName: String = ""

    // MARK: - Network
    var isSubmitting: Bool = false
    var errorMessage: String?

    // MARK: - Validation
    var isContactValid: Bool {
        switch contactMode {
        case .phone: return PhoneFormattingUtils.isValid(phoneNumber)
        case .email: return Self.isEmail(email)
        }
    }

    var isOtpValid: Bool { otpCode.count == 6 }
    var isNameValid: Bool { !displayName.trimmingCharacters(in: .whitespaces).isEmpty }

    // MARK: - Dependencies
    private let repository: AuthRepository

    /// Last step-1 payload — replayed verbatim by `resendOtp` so the
    /// backend gets the full phone/country/email body, not just the hash.
    /// Mirrors Flutter's `SignStep1Notifier._lastRequest`.
    private var lastSignStep1Request: SignStep1RequestModel?

    init(repository: AuthRepository? = nil) {
        // Default parameters can't touch `ServiceLocator.shared` because
        // the implicit init context isn't main-actor-isolated. Resolve
        // inside the body where `@MainActor` on the class applies.
        self.repository = repository ?? ServiceLocator.shared.authRepository
        bootstrap()
        observeSessionExpiry()
    }

    /// Listen for `error_code == 1001` events from APIClient. Tokens are
    /// already cleared by the client; we just have to flip the root state
    /// so RootView swings back to the auth flow.
    private func observeSessionExpiry() {
        NotificationCenter.default.addObserver(
            forName: .sessionExpired,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.handleSessionExpired()
            }
        }
    }

    private func handleSessionExpired() {
        guard state == .authenticated else { return }
        state = .unauthenticated
        authPath = NavigationPath()
        reset()
    }

    // MARK: - Lifecycle

    private func bootstrap() {
        // Authenticated users skip the auth stack entirely. Everyone
        // else lands on `OnboardView` (the stack's root) and proceeds
        // by pushing `.sign` / `.otp` / `.createName` onto `authPath`.
        state = ServiceLocator.shared.authTokens.isAuthenticated
            ? .authenticated
            : .unauthenticated
    }

    /// Called when the user taps the primary CTA on the onboarding screen.
    /// Pushes the sign-in screen — same Cupertino slide as the rest of
    /// the auth flow.
    func finishOnboarding() {
        authPath.append(AuthRoute.sign)
    }

    // MARK: - Step 1: send code

    func submitContact() async {
        guard isContactValid, !isSubmitting else { return }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            lastOtpChannel = contactMode
            let request: SignStep1RequestModel
            switch contactMode {
            case .phone:
                let dialDigits = selectedCountry.dialCode.replacingOccurrences(of: "+", with: "")
                let fullPhone = "\(dialDigits)\(phoneNumber)"
                contactDisplay = "+\(dialDigits) \(PhoneFormattingUtils.format(phoneNumber, isoCode: selectedCountry.id))"
                request = SignStep1RequestModel(
                    from: OtpChannel.whatsapp.rawValue,
                    phone: fullPhone,
                    countryId: selectedCountry.dbId,
                    dialCode: dialDigits
                )
            case .email:
                let trimmed = email.trimmingCharacters(in: .whitespaces)
                contactDisplay = Self.maskEmail(trimmed)
                request = SignStep1RequestModel(
                    email: trimmed,
                    countryId: selectedCountry.dbId
                )
            }
            lastSignStep1Request = request
            let response = try await repository.signStep1(request)
            otpHash = response.hash
            otpResendNonce += 1
            authPath.append(AuthRoute.otp)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resendOtp() async {
        guard let request = lastSignStep1Request, !isSubmitting else { return }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            let response = try await repository.signStep1(request)
            if let hash = response.hash { otpHash = hash }
            otpCode = ""
            showOtpError = false
            otpResendNonce += 1
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Step 2: verify code

    func verifyOtp() async {
        guard isOtpValid, let otpHash, !isSubmitting else { return }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            let response = try await repository.verifyOtp(hash: otpHash, code: otpCode)
            if let token = response.token, !token.isEmpty {
                // Existing user — token already persisted by repository.
                withTransition { state = .authenticated }
            } else {
                // New user — hash updated, push to name screen.
                self.otpHash = response.hash ?? otpHash
                authPath.append(AuthRoute.createName)
            }
        } catch {
            showOtpError = true
            Haptics.notify(.error)
        }
    }

    func clearOtpError() {
        if showOtpError { showOtpError = false }
    }

    // MARK: - Step 3: complete profile

    func completeProfile() async {
        guard isNameValid, let otpHash, !isSubmitting else { return }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await repository.completeProfile(
                hash: otpHash,
                username: displayName.trimmingCharacters(in: .whitespaces)
            )
            withTransition { state = .authenticated }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Social

    func signInWithApple(idToken: String, username: String?) async {
        guard !isSubmitting else { return }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            let response = try await repository.signInWithApple(
                idToken: idToken,
                username: username
            )
            if let token = response.token, !token.isEmpty {
                withTransition { state = .authenticated }
            } else if let hash = response.hash {
                self.otpHash = hash
                self.displayName = username ?? ""
                authPath.append(AuthRoute.createName)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signInWithGoogle() async {
        // TODO: integrate Google Sign-In SDK then forward idToken/username
        // to repository.signInWithApple-style backend handshake.
    }

    // MARK: - Navigation helpers

    /// Pop one step on the auth NavigationStack. At the root (OnboardView)
    /// there's nothing to pop — the call is a no-op.
    func goBack() {
        guard !authPath.isEmpty else { return }
        authPath.removeLast()
    }

    func logout() async {
        await repository.logout()
        state = .unauthenticated
        authPath = NavigationPath()
        reset()
    }

    private func reset() {
        phoneNumber = ""
        email = ""
        otpCode = ""
        otpHash = nil
        displayName = ""
        contactDisplay = ""
        showOtpError = false
        errorMessage = nil
    }

    private func withTransition(_ change: () -> Void) {
        // Animation is applied at the call site via `.animation` on the
        // coordinator; this hook exists for future telemetry / haptics.
        change()
    }

    // MARK: - Static helpers

    private static let emailRegex = try! NSRegularExpression(
        pattern: #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#,
        options: .caseInsensitive
    )

    /// Mask everything between the first 5 chars of the local part and
    /// the `@` — e.g. `fidan****@gmail.com`. Matches the Figma copy.
    static func maskEmail(_ email: String) -> String {
        guard let at = email.firstIndex(of: "@") else { return email }
        let local = email[..<at]
        let domain = email[at...]
        let visible = min(5, local.count)
        let prefix = local.prefix(visible)
        let stars = String(repeating: "*", count: max(local.count - visible, 4))
        return prefix + stars + domain
    }

    /// Add spaces every three digits — "70 383 12 34" style. Keeps the
    /// OTP "Code sent to" header readable.
    func prettyPhone(_ digits: String) -> String {
        var spaced = ""
        for (i, ch) in digits.enumerated() {
            if i > 0, i % 3 == 0 { spaced.append(" ") }
            spaced.append(ch)
        }
        return spaced
    }

    static func isEmail(_ s: String) -> Bool {
        let trimmed = s.trimmingCharacters(in: .whitespaces)
        let range = NSRange(trimmed.startIndex..., in: trimmed)
        return emailRegex.firstMatch(in: trimmed, range: range) != nil
    }
}
