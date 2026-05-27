import UIKit
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth

/// Mirrors the Flutter app's social sign-in flow 1:1:
///   1. Acquire native credential (Apple `identityToken` / Google `idToken`).
///   2. Wrap it in a Firebase credential and call `Auth.auth().signIn(with:)`.
///   3. Read the *Firebase* ID token from the resulting user — that's what
///      the backend's `/auth/sign/step1` accepts (it verifies via Firebase
///      Admin SDK).
///   4. Forward `from`, Firebase id-token, email, username into AuthStore.
///
/// Apple Sign-In additionally requires a raw nonce: the SDK is asked to
/// embed `sha256(rawNonce)` in the identity token's `nonce` claim, then
/// Firebase verifies the round-trip by hashing `rawNonce` itself. Without
/// this, `Auth.auth().signIn(with:)` rejects the credential with
/// `ERROR_INVALID_CREDENTIAL` and the sheet just closes silently.
enum SocialSignInLauncher {
    // The nonce must outlive the Apple sheet — capture it at request build
    // time and consume it in the completion handler. SwiftUI rebuilds views
    // around the button so a struct-level property won't survive; a static
    // box is the simplest fit.
    private static var pendingAppleNonce: String?
    private static var appleDelegate: AppleAuthDelegate?

    // MARK: - Google

    @MainActor
    static func launchGoogle(into store: AuthStore) {
        guard !store.isGoogleSubmitting, let presenter = topMostController() else { return }
        store.isGoogleSubmitting = true
        GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { result, error in
            // Cancel / error path: just drop the spinner.
            guard error == nil,
                  let result,
                  let googleIdToken = result.user.idToken?.tokenString
            else {
                Task { @MainActor in store.isGoogleSubmitting = false }
                return
            }

            let accessToken = result.user.accessToken.tokenString
            let profile = result.user.profile
            let credentialName = [profile?.givenName, profile?.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
                .trimmingCharacters(in: .whitespaces)

            Task { @MainActor in
                await signInWithFirebaseCredential(
                    GoogleAuthProvider.credential(
                        withIDToken: googleIdToken,
                        accessToken: accessToken
                    ),
                    from: "google",
                    fallbackName: credentialName,
                    fallbackEmail: profile?.email,
                    into: store
                )
                store.isGoogleSubmitting = false
            }
        }
    }

    // MARK: - Apple

    /// Prepares the Apple authorization request — pass this as the `onRequest`
    /// closure of `SignInWithAppleButton`. Generates a raw nonce, stores it,
    /// and embeds its SHA-256 in the request so the returned identity token
    /// carries a matching `nonce` claim Firebase can verify.
    static func prepareAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        pendingAppleNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }

    /// Triggers Apple Sign-In directly via `ASAuthorizationController` — use
    /// when the visible button is a custom-styled SwiftUI control rather than
    /// `SignInWithAppleButton` (Figma's glass pill on the onboarding screen).
    /// The native sheet still appears; this just skips the layered button.
    @MainActor
    static func launchApple(into store: AuthStore) {
        guard !store.isAppleSubmitting, let presenter = topMostController() else { return }
        store.isAppleSubmitting = true

        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        prepareAppleRequest(request)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        let delegate = AppleAuthDelegate(presenter: presenter) { result in
            Task { @MainActor in
                handleApple(result: result, into: store)
                appleDelegate = nil
            }
        }
        appleDelegate = delegate
        controller.delegate = delegate
        controller.presentationContextProvider = delegate
        controller.performRequests()
    }

    @MainActor
    static func handleApple(result: Result<ASAuthorization, Error>, into store: AuthStore) {
        guard case .success(let authorization) = result,
              let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8),
              let rawNonce = pendingAppleNonce
        else {
            pendingAppleNonce = nil
            store.isAppleSubmitting = false
            return
        }
        pendingAppleNonce = nil

        let credentialName = [credential.fullName?.givenName, credential.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)

        // Modern Firebase iOS API — `appleCredential(withIDToken:rawNonce:fullName:)`
        // is the only path that satisfies the nonce check. The Flutter app
        // uses an older Dart shim that bypasses this; on native iOS we must
        // use the explicit nonce flow.
        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: identityToken,
            rawNonce: rawNonce,
            fullName: credential.fullName
        )

        Task { @MainActor in
            await signInWithFirebaseCredential(
                firebaseCredential,
                from: "apple",
                fallbackName: credentialName,
                fallbackEmail: credential.email,
                into: store
            )
            store.isAppleSubmitting = false
        }
    }

    // MARK: - Firebase exchange

    @MainActor
    private static func signInWithFirebaseCredential(
        _ credential: AuthCredential,
        from provider: String,
        fallbackName: String,
        fallbackEmail: String?,
        into store: AuthStore
    ) async {
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            let user = authResult.user
            let firebaseIdToken = try await user.getIDToken()

            let username: String? = {
                if !fallbackName.isEmpty { return fallbackName }
                let display = user.displayName?.trimmingCharacters(in: .whitespaces) ?? ""
                return display.isEmpty ? nil : display
            }()
            let email = user.email ?? fallbackEmail

            await store.signInWithSocial(
                from: provider,
                idToken: firebaseIdToken,
                email: email,
                username: username
            )
        } catch {
            store.errorMessage = error.localizedDescription
        }
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

    // MARK: - ASAuthorizationController delegate

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

    // MARK: - Presenter lookup

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
