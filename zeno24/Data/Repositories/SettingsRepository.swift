import Foundation

final class SettingsRepository {
    private let service: SettingsService

    init(service: SettingsService) {
        self.service = service
    }

    func fetch() async throws -> SettingsResponseModel {
        try await service.fetchSettings()
    }

    func updateLanguage(_ code: String) async throws {
        try await service.updateLanguage(code)
    }
}
