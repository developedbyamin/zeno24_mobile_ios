import Foundation
import UIKit
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth

/// Talks to the auth backend (`/auth/sign/step1`/`step2`/`step3`, `/auth/logout`)
/// and also drives the native social sign-in flows. Social sign-in lives here
/// rather than in a separate service because, from the caller's perspective,
/// it's just another way of producing the inputs the same `/auth/sign/step1`
/// expects — the native + Firebase plumbing is an implementation detail of
/// "get me an id-token I can post to the backend".
final class AuthService {
    private let client: APIClient

    // Bridges Apple's delegate-based authorization API into an async result.
    // Held as a property so the controller's weak `delegate` reference stays
    // valid for the duration of the sheet.
    private var appleDelegate: AppleAuthDelegate?

    init(client: APIClient) {
        self.client = client
    }

    // MARK: - REST

    func signStep1(_ request: SignStep1RequestModel) async throws -> AppResponseModel<SignStep1ResponseModel> {
        try await client.send(APIPaths.Auth.signStep1, data: request)
    }

    func signStep2(_ request: SignStep2RequestModel) async throws -> AppResponseModel<SignStep2ResponseModel> {
        try await client.send(APIPaths.Auth.signStep2, data: request)
    }

    func signStep3(_ request: SignStep3RequestModel) async throws -> AppResponseModel<SignStep3ResponseModel> {
        try await client.send(APIPaths.Auth.signStep3, data: request)
    }

    func logout() async throws {
        struct Empty: Decodable {}
        let _: AppResponseModel<Empty>? = try? await client.send(APIPaths.Auth.logout, authenticated: true)
    }

    // MARK: - Social sign-in (Apple)

    /// Drives the full native Apple Sign-In flow: presents `ASAuthorizationController`,
    /// captures the identity token, exchanges it for a Firebase credential
    /// (with the nonce dance Firebase requires), and returns the Firebase
    /// ID token alongside the user's display name/email.
    ///
    /// Throws on cancellation, controller errors, or a failed Firebase
    /// exchange. The caller is expected to map those into UI-level error
    /// messages.
    @MainActor
    func signInWithApple() async throws -> SocialCredential {
        let rawNonce = Self.randomNonceString()

        let authorization = try await runAppleAuthorization(hashedNonce: Self.sha256(rawNonce))

        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8)
        else {
            throw NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Apple credential missing identity token"]
            )
        }

        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: identityToken,
            rawNonce: rawNonce,
            fullName: credential.fullName
        )

        let credentialName = [credential.fullName?.givenName, credential.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)

        return try await exchangeWithFirebase(
            credential: firebaseCredential,
            provider: "apple",
            fallbackName: credentialName,
            fallbackEmail: credential.email
        )
    }

    @MainActor
    private func runAppleAuthorization(hashedNonce: String) async throws -> ASAuthorization {
        guard let presenter = Self.topMostController() else {
            throw NSError(
                domain: "AuthService",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "No window scene available for Apple Sign-In"]
            )
        }

        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce

        return try await withCheckedThrowingContinuation { continuation in
            let delegate = AppleAuthDelegate(presenter: presenter) { [weak self] result in
                self?.appleDelegate = nil
                continuation.resume(with: result)
            }
            self.appleDelegate = delegate

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = delegate
            controller.presentationContextProvider = delegate
            controller.performRequests()
        }
    }

    // MARK: - Social sign-in (Google)

    @MainActor
    func signInWithGoogle() async throws -> SocialCredential {
        guard let presenter = Self.topMostController() else {
            throw NSError(
                domain: "AuthService",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "No window scene available for Google Sign-In"]
            )
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenter)
        guard let googleIdToken = result.user.idToken?.tokenString else {
            throw NSError(
                domain: "AuthService",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "Google credential missing id token"]
            )
        }

        let accessToken = result.user.accessToken.tokenString
        let profile = result.user.profile
        let credentialName = [profile?.givenName, profile?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)

        let firebaseCredential = GoogleAuthProvider.credential(
            withIDToken: googleIdToken,
            accessToken: accessToken
        )

        return try await exchangeWithFirebase(
            credential: firebaseCredential,
            provider: "google",
            fallbackName: credentialName,
            fallbackEmail: profile?.email
        )
    }

    // MARK: - Firebase exchange

    /// Hands the provider credential to Firebase, then pulls the Firebase ID
    /// token off the resulting user — that's the token the backend's
    /// `/auth/sign/step1` is set up to verify.
    private func exchangeWithFirebase(
        credential: AuthCredential,
        provider: String,
        fallbackName: String,
        fallbackEmail: String?
    ) async throws -> SocialCredential {
        let authResult = try await Auth.auth().signIn(with: credential)
        let user = authResult.user
        let firebaseIdToken = try await user.getIDToken()

        let username: String? = {
            if !fallbackName.isEmpty { return fallbackName }
            let display = user.displayName?.trimmingCharacters(in: .whitespaces) ?? ""
            return display.isEmpty ? nil : display
        }()

        return SocialCredential(
            provider: provider,
            idToken: firebaseIdToken,
            email: user.email ?? fallbackEmail,
            username: username
        )
    }

    // MARK: - Nonce helpers

    private static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        while remaining > 0 {
            var randoms = [UInt8](repeating: 0, count: 16)
            let status = SecRandomCopyBytes(kSecRandomDefault, randoms.count, &randoms)
            precondition(status == errSecSuccess, "SecRandomCopyBytes failed")
            for random in randoms where remaining > 0 {
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remaining -= 1
                }
            }
        }
        return result
    }

    private static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Presenter lookup

    @MainActor
    private static func topMostController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
        guard let scene else { return nil }
        let window = scene.windows.first(where: \.isKeyWindow) ?? scene.windows.first
        guard var top = window?.rootViewController else { return nil }
        while let presented = top.presentedViewController, !presented.isBeingDismissed {
            top = presented
        }
        return top
    }
}

// MARK: - Apple delegate

private final class AppleAuthDelegate: NSObject,
    ASAuthorizationControllerDelegate,
    ASAuthorizationControllerPresentationContextProviding {

    private let presenter: UIViewController
    private let completion: (Result<ASAuthorization, Error>) -> Void

    init(
        presenter: UIViewController,
        completion: @escaping (Result<ASAuthorization, Error>) -> Void
    ) {
        self.presenter = presenter
        self.completion = completion
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        completion(.success(authorization))
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        completion(.failure(error))
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        presenter.view.window ?? ASPresentationAnchor()
    }
}
