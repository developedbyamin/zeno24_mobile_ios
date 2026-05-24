import Foundation

/// Access + refresh token storage — mirrors auth_tokens.dart
final class AuthTokens {
    private enum Keys {
        static let access = "auth.access_token"
        static let refresh = "auth.refresh_token"
    }

    private let storage: SecureStorage

    init(storage: SecureStorage) {
        self.storage = storage
    }

    var accessToken: String? {
        get { storage.get(Keys.access) }
        set {
            if let v = newValue { storage.set(v, for: Keys.access) }
            else { storage.remove(Keys.access) }
        }
    }

    var refreshToken: String? {
        get { storage.get(Keys.refresh) }
        set {
            if let v = newValue { storage.set(v, for: Keys.refresh) }
            else { storage.remove(Keys.refresh) }
        }
    }

    var isAuthenticated: Bool { accessToken != nil }

    func clear() {
        accessToken = nil
        refreshToken = nil
    }
}
