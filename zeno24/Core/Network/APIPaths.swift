import Foundation

/// API endpoint paths — mirrors lib/core/network/api_paths.dart
enum APIPaths {
    /// Mirrors Flutter `test.env` → `BASE_URL`. Plain HTTP requires the
    /// matching `NSAppTransportSecurity` exception in Info.plist.
    static let baseURL = "http://46.224.105.203:84"

    // MARK: Auth
    enum Auth {
        static let signStep1 = "/auth/sign/step1"
        static let signStep2 = "/auth/sign/step2"
        static let signStep3 = "/auth/sign/step3"
        static let refresh   = "/auth/refresh"
        static let logout    = "/auth/logout"
        static let google    = "/auth/google"
        static let apple     = "/auth/apple"
    }

    // MARK: Settings
    enum Settings {
        static let main      = "/main/settings"
        static let update    = "/settings/update"
        static let language  = "/settings/language"
    }

    // MARK: Circles
    enum Circles {
        static let list       = "/circles/list"
        static let add        = "/circles/add"
        static let info       = "/circles/info"
        static let join       = "/circles/join"
        static let invite     = "/circles/invite"
        static let switchCircle = "/circles/switch"
    }

    // MARK: Markers
    enum Markers {
        static let sync       = "/markers/sync"
        static let history    = "/markers/history"
    }
}
