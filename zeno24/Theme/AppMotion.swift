import SwiftUI

enum AppMotion {
    static let fast    = Animation.easeOut(duration: 0.15)
    static let medium  = Animation.easeInOut(duration: 0.25)
    static let slow    = Animation.easeInOut(duration: 0.4)
    static let bouncy  = Animation.spring(response: 0.4, dampingFraction: 0.7)
}
