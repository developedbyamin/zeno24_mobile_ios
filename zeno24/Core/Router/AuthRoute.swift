import Foundation

/// Typed routes pushed onto the auth NavigationStack so SwiftUI applies
/// the native iOS push transition (slide-from-right + dim).
enum AuthRoute: Hashable {
    case sign           // phone / email entry
    case otp            // 6-digit code
    case createName     // display name for new users
}
