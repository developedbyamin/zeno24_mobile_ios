import Foundation

/// Predefined one-tap reply (Figma 5865:7250). Each case maps to a label, an
/// emoji asset shown inside the chip, and the message string that gets
/// posted when the user taps it.
enum ChatQuickReply: String, CaseIterable, Identifiable {
    case love, hello, write, call

    var id: String { rawValue }

    var title: String {
        switch self {
        case .love:  AppStrings.Chat.quickLoveYou
        case .hello: AppStrings.Chat.quickSayHello
        case .write: AppStrings.Chat.quickWriteMe
        case .call:  AppStrings.Chat.quickCallMe
        }
    }

    var iconAsset: String {
        switch self {
        case .love:  AppImages.emojiHeartRed
        case .hello: AppImages.emojiWave
        case .write: AppImages.emojiChatBubble
        case .call:  AppImages.emojiPhone
        }
    }

    var message: String {
        switch self {
        case .love:  "Love you ❤️"
        case .hello: "Hello! 👋"
        case .write: "Write me when you can 💬"
        case .call:  "Call me 📞"
        }
    }
}
