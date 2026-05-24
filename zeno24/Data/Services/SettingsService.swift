import Foundation

/// Settings API service — mirrors settings_service.dart.
/// Request goes through `AppRequestModel(token: ...)`. The response shape
/// is non-standard (no AppResponseModel envelope) — `account_data`,
/// `circle_data`, `lang`, `langs`, `permissions` live at the root, so we
/// decode `SettingsResponseModel` directly.
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
