import Foundation

/// SF Symbol names for tab bars and system-style chrome. The brand-specific
/// vector glyphs (back arrow, apple logo, google logo etc.) live in
/// `AppVectors` — this enum holds only Apple's built-in symbols.
enum AppIcons {
    static let home          = "house"
    static let homeFill      = "house.fill"
    static let messages      = "message"
    static let messagesFill  = "message.fill"
    static let bell          = "bell"
    static let bellFill      = "bell.fill"
    static let profile       = "person.circle"
    static let profileFill   = "person.circle.fill"
    static let settings      = "gearshape"
    static let settingsFill  = "gearshape.fill"
    static let close         = "xmark"
    static let back          = "chevron.left"
    static let forward       = "chevron.right"
}
