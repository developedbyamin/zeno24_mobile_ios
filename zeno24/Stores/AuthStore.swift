import Foundation
import SwiftUI

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

    private var lastSignStep1Request: SignStep1RequestModel?

    init(repository: AuthRepository? = nil) {
        // Default parameters can't touch `ServiceLocator.shared` because
        // the implicit init context isn't main-actor-isolated. Resolve
        // inside the body where `@MainActor` on the class applies.
        self.repository = repository ?? ServiceLocator.shared.authRepository
        bootstrap()
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

    private func bootstrap() {
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
                withTransition { state = .authenticated }
            } else {
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
