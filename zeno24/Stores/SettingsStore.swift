import Foundation

@MainActor
@Observable
final class SettingsStore {
    var account: SettingsAccountModel?
    var activeCircle: SettingsCircleModel?
    var activeLang: LangModel?
    var availableLangs: [LangModel] = []
    var permissions: [String] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var hasLoaded: Bool = false

    private let repository: SettingsRepository

    init(repository: SettingsRepository? = nil) {
        self.repository = repository ?? ServiceLocator.shared.settingsRepository
    }

    /// Fetches the full settings payload (account, active circle, language,
    /// available languages, permissions) from `/main/settings`. Mirrors the
    /// Flutter `SettingsNotifier._load` flow — token is attached in-body by
    /// `SettingsService`, no envelope on the response.
    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await repository.fetch()
            account = response.accountData
            activeCircle = response.circleData
            activeLang = response.lang
            availableLangs = response.langs ?? []
            permissions = response.permissions ?? []
            hasLoaded = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func reset() {
        account = nil
        activeCircle = nil
        activeLang = nil
        availableLangs = []
        permissions = []
        hasLoaded = false
        errorMessage = nil
    }

    var displayName: String {
        if let full = account?.fullname?.trimmed, !full.isEmpty { return full }
        let composed = [account?.firstname, account?.lastname]
            .compactMap { $0?.trimmed }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        if !composed.isEmpty { return composed }
        return account?.username ?? ""
    }

    var displayEmail: String {
        account?.email?.trimmed ?? ""
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
