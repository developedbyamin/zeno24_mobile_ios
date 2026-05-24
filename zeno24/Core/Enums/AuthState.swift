import Foundation

/// High-level authentication state used by RootView. The onboarding /
/// sign-in / OTP / create-name screens all live on the same
/// `NavigationStack`; only the top-level state decides whether to show
/// that stack or the main app.
enum AuthState: Equatable {
    case loading
    case unauthenticated
    case authenticated
}

/// Mode toggle on the contact entry screen.
enum AuthContactMode: String {
    case email
    case phone
}

/// OTP delivery channel sent to the server.
enum OtpChannel: String, Codable {
    case sms
    case whatsapp
    case email
}
