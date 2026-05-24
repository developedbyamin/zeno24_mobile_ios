import Foundation

/// Route identifiers — mirrors lib/core/router/route_names.dart
enum RouteNames {
    // Auth
    static let splash       = "splash"
    static let onboard      = "onboard"
    static let signIn       = "sign_in"
    static let signOtp      = "sign_otp"
    static let createName   = "create_name"

    // Main
    static let main         = "main"
    static let home         = "home"
    static let messages     = "messages"
    static let chat         = "chat"
    static let notifications = "notifications"
    static let profile      = "profile"
    static let settings     = "settings"

    // Features
    static let health       = "health"
    static let kids         = "kids"
    static let driving      = "driving"
    static let premium      = "premium"
}
