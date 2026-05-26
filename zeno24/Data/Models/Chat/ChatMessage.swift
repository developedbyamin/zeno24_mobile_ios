import Foundation

/// One message inside a chat thread. Stays a value type so SwiftUI can diff
/// the list cheaply when new entries get appended.
struct ChatMessage: Identifiable, Hashable {
    let id: String
    let text: String
    let time: String
    let date: String
    let isOutgoing: Bool
    var isSeen: Bool
}

extension ChatMessage {
    /// Mock thread used until the messaging backend lands. Two-message
    /// opener that matches Figma 5865:7143 frame.
    static let seed: [ChatMessage] = [
        ChatMessage(
            id: "1",
            text: "Hey sweetie, I see you just left school. Do you want me to pick you up or are you walking with Emma today? 🥰",
            time: "12:25 PM",
            date: "Dec 03",
            isOutgoing: false,
            isSeen: true
        ),
        ChatMessage(
            id: "2",
            text: "Do you want me to pick you up or are you walking with Emma today? 🥰",
            time: "12:30 PM",
            date: "Dec 03",
            isOutgoing: true,
            isSeen: true
        ),
    ]
}
