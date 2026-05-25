import Foundation

final class AuthService {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

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
}
