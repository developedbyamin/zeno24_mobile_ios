import Foundation

final class AuthRepository {
    private let service: AuthService
    private let tokens: AuthTokens

    init(service: AuthService, tokens: AuthTokens) {
        self.service = service
        self.tokens = tokens
    }

    // MARK: - Step 1

    func signStep1(_ request: SignStep1RequestModel) async throws -> SignStep1ResponseModel {
        let response = try await service.signStep1(request)
        return response.data ?? SignStep1ResponseModel(hash: nil, text: nil)
    }

    // MARK: - Step 2

    func verifyOtp(hash: String, code: String) async throws -> SignStep2ResponseModel {
        let response = try await service.signStep2(.init(hash: hash, code: code))
        if let token = response.token, !token.isEmpty {
            tokens.accessToken = token
        }
        return SignStep2ResponseModel(token: response.token, hash: response.data?.hash)
    }

    // MARK: - Step 3

    func completeProfile(hash: String, username: String) async throws {
        let response = try await service.signStep3(.init(hash: hash, username: username))
        if let token = response.token, !token.isEmpty {
            tokens.accessToken = token
        }
    }

    // MARK: - Social

    /// End-to-end Apple Sign-In: drives the native sheet via `AuthService`,
    /// then ships the resulting Firebase id-token through `/auth/sign/step1`.
    @MainActor
    func signInWithApple() async throws -> (response: SignStep2ResponseModel, username: String?) {
        let credential = try await service.signInWithApple()
        let response = try await exchangeWithBackend(credential)
        return (response, credential.username)
    }

    /// End-to-end Google Sign-In — same shape as Apple.
    @MainActor
    func signInWithGoogle() async throws -> (response: SignStep2ResponseModel, username: String?) {
        let credential = try await service.signInWithGoogle()
        let response = try await exchangeWithBackend(credential)
        return (response, credential.username)
    }

    /// Mirrors the Flutter contract for `/auth/sign/step1` social sign-in:
    /// `from` is `"apple"` or `"google"`, `id_token` is the **Firebase** ID
    /// token (not the raw Apple/Google one — Flutter wraps the credential in
    /// Firebase first), plus `email`, `username`, and a hard-coded
    /// `country_id` of 1 to match the Flutter payload exactly.
    private func exchangeWithBackend(_ credential: SocialCredential) async throws -> SignStep2ResponseModel {
        let step1Response = try await service.signStep1(.init(
            from: credential.provider,
            email: credential.email,
            countryId: 1,
            idToken: credential.idToken,
            username: credential.username
        ))
        // Some social sign-ins authenticate directly on step1 (Flutter checks
        // `response.token` here, not `data.hash`). Handle both shapes.
        if let token = step1Response.token, !token.isEmpty {
            tokens.accessToken = token
            return SignStep2ResponseModel(token: token, hash: nil)
        }
        guard let hash = step1Response.data?.hash else { throw APIError.invalidResponse }
        let step2 = try await service.signStep2(.init(hash: hash, code: ""))
        if let token = step2.token { tokens.accessToken = token }
        return SignStep2ResponseModel(token: step2.token, hash: step2.data?.hash)
    }

    // MARK: - Logout

    func logout() async {
        try? await service.logout()
        tokens.clear()
    }
}
