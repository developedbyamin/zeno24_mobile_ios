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

    func signInWithApple(idToken: String, username: String?) async throws -> SignStep2ResponseModel {
        let step1 = try await service.signStep1(.init(
            from: "apple",
            idToken: idToken,
            username: username
        ))
        guard let hash = step1.data?.hash else { throw APIError.invalidResponse }
        let response = try await service.signStep2(.init(hash: hash, code: ""))
        if let token = response.token { tokens.accessToken = token }
        return SignStep2ResponseModel(token: response.token, hash: response.data?.hash)
    }

    // MARK: - Logout

    func logout() async {
        try? await service.logout()
        tokens.clear()
    }
}
