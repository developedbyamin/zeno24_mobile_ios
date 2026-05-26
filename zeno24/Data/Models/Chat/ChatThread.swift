import Foundation

/// Lightweight value type identifying a chat conversation pushed onto the
/// nav stack. Routes need to be `Hashable`, so this stays plain data —
/// avatar assets / messages are looked up by the receiving view rather than
/// embedded in the route.
struct ChatThread: Hashable, Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let avatarAsset: String?
    let avatarInitialBackground: UInt32

    init(
        id: String,
        title: String,
        subtitle: String,
        avatarAsset: String? = nil,
        avatarInitialBackground: UInt32 = 0xFF5F03
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.avatarAsset = avatarAsset
        self.avatarInitialBackground = avatarInitialBackground
    }
}
