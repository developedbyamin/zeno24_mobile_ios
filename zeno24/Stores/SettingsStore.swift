import Foundation

@MainActor
@Observable
final class SettingsStore {
    var account: SettingsAccountModel?
    var activeCircle: SettingsCircleModel?
    var isLoading: Bool = false
    var errorMessage: String?

    private let repository: SettingsRepository

    init(repository: SettingsRepository? = nil) {
        self.repository = repository ?? ServiceLocator.shared.settingsRepository
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await repository.fetch()
            account = response.account
            activeCircle = response.circle
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
