import Foundation

/// Singleton-style service locator (mirrors lib/service_locator.dart).
/// Prefer @Environment injection in views; this is for non-view layers
/// (services/repositories/stores) that need shared instances.
@MainActor
final class ServiceLocator {
    static let shared = ServiceLocator()

    // MARK: Storage
    lazy var secureStorage: SecureStorage = SecureStorage()
    lazy var authTokens: AuthTokens = AuthTokens(storage: secureStorage)

    // MARK: Network
    lazy var apiClient: APIClient = APIClient(authTokens: authTokens)

    // MARK: Services
    lazy var authService: AuthService = AuthService(client: apiClient)
    lazy var settingsService: SettingsService = SettingsService(client: apiClient, authTokens: authTokens)
    lazy var markersService: MarkersService = MarkersService()
    lazy var circlesService: CirclesService = CirclesService(client: apiClient)

    // MARK: Repositories
    lazy var authRepository: AuthRepository = AuthRepository(service: authService, tokens: authTokens)
    lazy var settingsRepository: SettingsRepository = SettingsRepository(service: settingsService)
    lazy var markersRepository: MarkersRepository = MarkersRepository(service: markersService)
    lazy var circlesRepository: CirclesRepository = CirclesRepository(service: circlesService)

    private init() {}
}
