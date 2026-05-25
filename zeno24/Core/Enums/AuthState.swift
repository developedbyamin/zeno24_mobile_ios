import Foundation

enum AuthState: Equatable {
    case loading
    case unauthenticated
    case authenticated
}

enum AuthContactMode: String {
    case email
    case phone
}

enum OtpChannel: String, Codable {
    case sms
    case whatsapp
    case email
}
