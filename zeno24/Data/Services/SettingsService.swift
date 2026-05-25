import Foundation

final class SettingsService {
    private let client: APIClient
    private let authTokens: AuthTokens

    init(client: APIClient, authTokens: AuthTokens) {
        self.client = client
        self.authTokens = authTokens
    }

    func fetchSettings() async throws -> SettingsResponseModel {
        struct Empty: Encodable {}
        let body = AppRequestModel<Empty>(token: authTokens.accessToken)
        return try await client.post(APIPaths.Settings.main, body: body)
    }

    func updateLanguage(_ code: String) async throws {
        struct Body: Encodable { let code: String }
        struct Empty: Decodable {}
        let _: AppResponseModel<Empty>? = try? await client.send(
            APIPaths.Settings.language,
            data: Body(code: code),
            authenticated: true
        )
    }
}
