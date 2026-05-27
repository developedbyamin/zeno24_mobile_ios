import Foundation
import SwiftUI
import AuthenticationServices
import GoogleSignIn

@MainActor
@Observable
final class AuthStore {
    // MARK: - Root state
    var state: AuthState = .loading

    // MARK: - Auth NavigationStack path
    var authPath = NavigationPath()

    // MARK: - Contact entry
    var contactMode: AuthContactMode = .email
    var phoneNumber: String = ""
    var selectedCountry: Country = CountriesData.byCode("AZ") ?? CountriesData.all[0]
    var email: String = ""

    var contactDisplay: String = ""

    var lastOtpChannel: AuthContactMode = .email

    // MARK: - OTP entry
    var otpCode: String = ""
    var otpHash: String?
    var otpResendNonce: Int = 0
    var showOtpError: Bool = false
    /// Drives the OTP screen header copy: returning users get
    /// "Welcome back!", first-time users get "Enter the code sent to ...".
    /// `nil` (e.g. legacy responses) is treated as returning.
    var isRegistered: Bool = true
    /// Masked contact string from step1 (`a****ay@gmail.com`). Shown
    /// underneath the OTP header for first-time users.
    var maskedContact: String?

    // MARK: - Create name
    var displayName: String = ""

    // MARK: - Network
    var isSubmitting: Bool = false
    var isAppleSubmitting: Bool = false
    var isGoogleSubmitting: Bool = false
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

    /// BootstrapStore is wired in from `zeno24App` after both stores exist.
    /// When sign-in succeeds we run bootstrap **before** flipping `state` to
    /// `.authenticated` so the user goes straight from the auth screen (with
    /// its spinner still showing) into MainView — no SplashView flash in
    /// between.
    weak var bootstrap: BootstrapStore?

    private var lastSignStep1Request: SignStep1RequestModel?

    init(repository: AuthRepository? = nil) {
        // Default parameters can't touch `ServiceLocator.shared` because
        // the implicit init context isn't main-actor-isolated. Resolve
        // inside the body where `@MainActor` on the class applies.
        self.repository = repository ?? ServiceLocator.shared.authRepository
        restoreInitialState()
        observeSessionExpiry()
    }

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

    private func restoreInitialState() {
        state = ServiceLocator.shared.authTokens.isAuthenticated
            ? .authenticated
            : .unauthenticated
    }

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
            isRegistered = (response.isRegistered ?? 1) == 1
            maskedContact = response.text
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
            if let registered = response.isRegistered { isRegistered = registered == 1 }
            if let masked = response.text { maskedContact = masked }
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
        do {
            let response = try await repository.verifyOtp(hash: otpHash, code: otpCode)
            if let token = response.token, !token.isEmpty {
                await finishAuthentication()
            } else {
                self.otpHash = response.hash ?? otpHash
                authPath.append(AuthRoute.createName)
                isSubmitting = false
            }
        } catch {
            showOtpError = true
            Haptics.notify(.error)
            isSubmitting = false
        }
    }

    func clearOtpError() {
        if showOtpError { showOtpError = false }
    }

    // MARK: - Step 3: complete profile

    func completeProfile() async {
        guard isNameValid, let otpHash, !isSubmitting else { return }
        isSubmitting = true
        do {
            try await repository.completeProfile(
                hash: otpHash,
                username: displayName.trimmingCharacters(in: .whitespaces)
            )
            await finishAuthentication()
        } catch {
            errorMessage = error.localizedDescription
            isSubmitting = false
        }
    }

    // MARK: - Social

    func signInWithApple() async {
        guard !isAppleSubmitting else { return }
        isAppleSubmitting = true
        await runSocialSignIn { try await self.repository.signInWithApple() }
        isAppleSubmitting = false
    }

    func signInWithGoogle() async {
        guard !isGoogleSubmitting else { return }
        isGoogleSubmitting = true
        await runSocialSignIn { try await self.repository.signInWithGoogle() }
        isGoogleSubmitting = false
    }

    private func runSocialSignIn(
        _ request: () async throws -> (response: SignStep2ResponseModel, username: String?)
    ) async {
        do {
            let result = try await request()
            if let token = result.response.token, !token.isEmpty {
                await finishAuthentication()
            } else if let hash = result.response.hash {
                self.otpHash = hash
                self.displayName = result.username ?? ""
                authPath.append(AuthRoute.createName)
            }
        } catch let error as NSError where error.domain == ASAuthorizationError.errorDomain
                                        && error.code == ASAuthorizationError.canceled.rawValue {
            // User dismissed the Apple sheet — silently drop, matches Flutter.
        } catch let error as NSError where error.code == GIDSignInError.canceled.rawValue
                                        && error.domain == kGIDSignInErrorDomain {
            // User dismissed the Google sheet.
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Runs `/main/settings` + `/circles/list` + the marker sync *while* the
    /// user is still looking at the auth screen (its button keeps its
    /// spinner). Only after bootstrap reports `.ready` do we flip `state` to
    /// `.authenticated` — RootView then renders MainView directly, with no
    /// SplashView in between.
    private func finishAuthentication() async {
        if let bootstrap, bootstrap.state != .ready {
            bootstrap.start()
            // Wait for bootstrap to land on `.ready` by polling — keeps the
            // store free of Combine boilerplate and works against an
            // `@Observable` whose changes propagate via the SwiftUI runtime
            // rather than a publisher we can `.values` on directly.
            while bootstrap.state != .ready {
                try? await Task.sleep(for: .milliseconds(40))
            }
        }
        isSubmitting = false
        withTransition { state = .authenticated }
    }

    // MARK: - Navigation helpers

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
        change()
    }

    // MARK: - Static helpers

    private static let emailRegex = try! NSRegularExpression(
        pattern: #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#,
        options: .caseInsensitive
    )

    static func maskEmail(_ email: String) -> String {
        guard let at = email.firstIndex(of: "@") else { return email }
        let local = email[..<at]
        let domain = email[at...]
        let visible = min(5, local.count)
        let prefix = local.prefix(visible)
        let stars = String(repeating: "*", count: max(local.count - visible, 4))
        return prefix + stars + domain
    }

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
