import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "add_user" asset catalog image resource.
    static let addUser = DeveloperToolsSupport.ImageResource(name: "add_user", bundle: resourceBundle)

    /// The "alerts" asset catalog image resource.
    static let alerts = DeveloperToolsSupport.ImageResource(name: "alerts", bundle: resourceBundle)

    /// The "app_instagram" asset catalog image resource.
    static let appInstagram = DeveloperToolsSupport.ImageResource(name: "app_instagram", bundle: resourceBundle)

    /// The "app_pubg" asset catalog image resource.
    static let appPubg = DeveloperToolsSupport.ImageResource(name: "app_pubg", bundle: resourceBundle)

    /// The "app_tiktok" asset catalog image resource.
    static let appTiktok = DeveloperToolsSupport.ImageResource(name: "app_tiktok", bundle: resourceBundle)

    /// The "app_youtube" asset catalog image resource.
    static let appYoutube = DeveloperToolsSupport.ImageResource(name: "app_youtube", bundle: resourceBundle)

    /// The "apple_logo" asset catalog image resource.
    static let appleLogo = DeveloperToolsSupport.ImageResource(name: "apple_logo", bundle: resourceBundle)

    /// The "arrow_down" asset catalog image resource.
    static let arrowDown = DeveloperToolsSupport.ImageResource(name: "arrow_down", bundle: resourceBundle)

    /// The "arrow_right" asset catalog image resource.
    static let arrowRight = DeveloperToolsSupport.ImageResource(name: "arrow_right", bundle: resourceBundle)

    /// The "auto_satellite_map" asset catalog image resource.
    static let autoSatelliteMap = DeveloperToolsSupport.ImageResource(name: "auto_satellite_map", bundle: resourceBundle)

    /// The "avatar_chat_me" asset catalog image resource.
    static let avatarChatMe = DeveloperToolsSupport.ImageResource(name: "avatar_chat_me", bundle: resourceBundle)

    /// The "avatar_chat_other" asset catalog image resource.
    static let avatarChatOther = DeveloperToolsSupport.ImageResource(name: "avatar_chat_other", bundle: resourceBundle)

    /// The "avatar_fidan" asset catalog image resource.
    static let avatarFidan = DeveloperToolsSupport.ImageResource(name: "avatar_fidan", bundle: resourceBundle)

    /// The "avatar_fidan_chat" asset catalog image resource.
    static let avatarFidanChat = DeveloperToolsSupport.ImageResource(name: "avatar_fidan_chat", bundle: resourceBundle)

    /// The "avatar_firuza" asset catalog image resource.
    static let avatarFiruza = DeveloperToolsSupport.ImageResource(name: "avatar_firuza", bundle: resourceBundle)

    /// The "avatar_nigar" asset catalog image resource.
    static let avatarNigar = DeveloperToolsSupport.ImageResource(name: "avatar_nigar", bundle: resourceBundle)

    /// The "back_arrow" asset catalog image resource.
    static let backArrow = DeveloperToolsSupport.ImageResource(name: "back_arrow", bundle: resourceBundle)

    /// The "cancle_outline" asset catalog image resource.
    static let cancleOutline = DeveloperToolsSupport.ImageResource(name: "cancle_outline", bundle: resourceBundle)

    /// The "car" asset catalog image resource.
    static let car = DeveloperToolsSupport.ImageResource(name: "car", bundle: resourceBundle)

    /// The "car_filled" asset catalog image resource.
    static let carFilled = DeveloperToolsSupport.ImageResource(name: "car_filled", bundle: resourceBundle)

    /// The "charge_battery" asset catalog image resource.
    static let chargeBattery = DeveloperToolsSupport.ImageResource(name: "charge_battery", bundle: resourceBundle)

    /// The "chat" asset catalog image resource.
    static let chat = DeveloperToolsSupport.ImageResource(name: "chat", bundle: resourceBundle)

    /// The "chat_bubble_tail_left" asset catalog image resource.
    static let chatBubbleTailLeft = DeveloperToolsSupport.ImageResource(name: "chat_bubble_tail_left", bundle: resourceBundle)

    /// The "chat_bubble_tail_right" asset catalog image resource.
    static let chatBubbleTailRight = DeveloperToolsSupport.ImageResource(name: "chat_bubble_tail_right", bundle: resourceBundle)

    /// The "chat_seen_check" asset catalog image resource.
    static let chatSeenCheck = DeveloperToolsSupport.ImageResource(name: "chat_seen_check", bundle: resourceBundle)

    /// The "chat_send_button" asset catalog image resource.
    static let chatSendButton = DeveloperToolsSupport.ImageResource(name: "chat_send_button", bundle: resourceBundle)

    /// The "checkmark" asset catalog image resource.
    static let checkmark = DeveloperToolsSupport.ImageResource(name: "checkmark", bundle: resourceBundle)

    /// The "chevron_down" asset catalog image resource.
    static let chevronDown = DeveloperToolsSupport.ImageResource(name: "chevron_down", bundle: resourceBundle)

    /// The "circle_clock" asset catalog image resource.
    static let circleClock = DeveloperToolsSupport.ImageResource(name: "circle_clock", bundle: resourceBundle)

    /// The "circle_grid_interface" asset catalog image resource.
    static let circleGridInterface = DeveloperToolsSupport.ImageResource(name: "circle_grid_interface", bundle: resourceBundle)

    /// The "close_circle" asset catalog image resource.
    static let closeCircle = DeveloperToolsSupport.ImageResource(name: "close_circle", bundle: resourceBundle)

    /// The "close_small" asset catalog image resource.
    static let closeSmall = DeveloperToolsSupport.ImageResource(name: "close_small", bundle: resourceBundle)

    /// The "danger" asset catalog image resource.
    static let danger = DeveloperToolsSupport.ImageResource(name: "danger", bundle: resourceBundle)

    /// The "diamond_star" asset catalog image resource.
    static let diamondStar = DeveloperToolsSupport.ImageResource(name: "diamond_star", bundle: resourceBundle)

    /// The "earth" asset catalog image resource.
    static let earth = DeveloperToolsSupport.ImageResource(name: "earth", bundle: resourceBundle)

    /// The "emoji_bell" asset catalog image resource.
    static let emojiBell = DeveloperToolsSupport.ImageResource(name: "emoji_bell", bundle: resourceBundle)

    /// The "emoji_car" asset catalog image resource.
    static let emojiCar = DeveloperToolsSupport.ImageResource(name: "emoji_car", bundle: resourceBundle)

    /// The "emoji_chat_bubble" asset catalog image resource.
    static let emojiChatBubble = DeveloperToolsSupport.ImageResource(name: "emoji_chat_bubble", bundle: resourceBundle)

    /// The "emoji_clapping_hands" asset catalog image resource.
    static let emojiClappingHands = DeveloperToolsSupport.ImageResource(name: "emoji_clapping_hands", bundle: resourceBundle)

    /// The "emoji_clock_2" asset catalog image resource.
    static let emojiClock2 = DeveloperToolsSupport.ImageResource(name: "emoji_clock_2", bundle: resourceBundle)

    /// The "emoji_crown" asset catalog image resource.
    static let emojiCrown = DeveloperToolsSupport.ImageResource(name: "emoji_crown", bundle: resourceBundle)

    /// The "emoji_dog" asset catalog image resource.
    static let emojiDog = DeveloperToolsSupport.ImageResource(name: "emoji_dog", bundle: resourceBundle)

    /// The "emoji_gift" asset catalog image resource.
    static let emojiGift = DeveloperToolsSupport.ImageResource(name: "emoji_gift", bundle: resourceBundle)

    /// The "emoji_heart_red" asset catalog image resource.
    static let emojiHeartRed = DeveloperToolsSupport.ImageResource(name: "emoji_heart_red", bundle: resourceBundle)

    /// The "emoji_listen" asset catalog image resource.
    static let emojiListen = DeveloperToolsSupport.ImageResource(name: "emoji_listen", bundle: resourceBundle)

    /// The "emoji_locked" asset catalog image resource.
    static let emojiLocked = DeveloperToolsSupport.ImageResource(name: "emoji_locked", bundle: resourceBundle)

    /// The "emoji_logout_3d" asset catalog image resource.
    static let emojiLogout3D = DeveloperToolsSupport.ImageResource(name: "emoji_logout_3d", bundle: resourceBundle)

    /// The "emoji_megaphone" asset catalog image resource.
    static let emojiMegaphone = DeveloperToolsSupport.ImageResource(name: "emoji_megaphone", bundle: resourceBundle)

    /// The "emoji_open_envelope" asset catalog image resource.
    static let emojiOpenEnvelope = DeveloperToolsSupport.ImageResource(name: "emoji_open_envelope", bundle: resourceBundle)

    /// The "emoji_phone" asset catalog image resource.
    static let emojiPhone = DeveloperToolsSupport.ImageResource(name: "emoji_phone", bundle: resourceBundle)

    /// The "emoji_running" asset catalog image resource.
    static let emojiRunning = DeveloperToolsSupport.ImageResource(name: "emoji_running", bundle: resourceBundle)

    /// The "emoji_screen_limit" asset catalog image resource.
    static let emojiScreenLimit = DeveloperToolsSupport.ImageResource(name: "emoji_screen_limit", bundle: resourceBundle)

    /// The "emoji_screenshot" asset catalog image resource.
    static let emojiScreenshot = DeveloperToolsSupport.ImageResource(name: "emoji_screenshot", bundle: resourceBundle)

    /// The "emoji_sharp_stop" asset catalog image resource.
    static let emojiSharpStop = DeveloperToolsSupport.ImageResource(name: "emoji_sharp_stop", bundle: resourceBundle)

    /// The "emoji_speech_bubbles" asset catalog image resource.
    static let emojiSpeechBubbles = DeveloperToolsSupport.ImageResource(name: "emoji_speech_bubbles", bundle: resourceBundle)

    /// The "emoji_speed" asset catalog image resource.
    static let emojiSpeed = DeveloperToolsSupport.ImageResource(name: "emoji_speed", bundle: resourceBundle)

    /// The "emoji_unlock" asset catalog image resource.
    static let emojiUnlock = DeveloperToolsSupport.ImageResource(name: "emoji_unlock", bundle: resourceBundle)

    /// The "emoji_warning" asset catalog image resource.
    static let emojiWarning = DeveloperToolsSupport.ImageResource(name: "emoji_warning", bundle: resourceBundle)

    /// The "emoji_warning_3d" asset catalog image resource.
    static let emojiWarning3D = DeveloperToolsSupport.ImageResource(name: "emoji_warning_3d", bundle: resourceBundle)

    /// The "emoji_wave" asset catalog image resource.
    static let emojiWave = DeveloperToolsSupport.ImageResource(name: "emoji_wave", bundle: resourceBundle)

    /// The "fire" asset catalog image resource.
    static let fire = DeveloperToolsSupport.ImageResource(name: "fire", bundle: resourceBundle)

    /// The "flash" asset catalog image resource.
    static let flash = DeveloperToolsSupport.ImageResource(name: "flash", bundle: resourceBundle)

    /// The "frame" asset catalog image resource.
    static let frame = DeveloperToolsSupport.ImageResource(name: "frame", bundle: resourceBundle)

    /// The "full_battery" asset catalog image resource.
    static let fullBattery = DeveloperToolsSupport.ImageResource(name: "full_battery", bundle: resourceBundle)

    /// The "gem" asset catalog image resource.
    static let gem = DeveloperToolsSupport.ImageResource(name: "gem", bundle: resourceBundle)

    /// The "google_logo" asset catalog image resource.
    static let googleLogo = DeveloperToolsSupport.ImageResource(name: "google_logo", bundle: resourceBundle)

    /// The "heart" asset catalog image resource.
    static let heart = DeveloperToolsSupport.ImageResource(name: "heart", bundle: resourceBundle)

    /// The "heart_rate" asset catalog image resource.
    static let heartRate = DeveloperToolsSupport.ImageResource(name: "heart_rate", bundle: resourceBundle)

    /// The "home" asset catalog image resource.
    static let home = DeveloperToolsSupport.ImageResource(name: "home", bundle: resourceBundle)

    /// The "journey" asset catalog image resource.
    static let journey = DeveloperToolsSupport.ImageResource(name: "journey", bundle: resourceBundle)

    /// The "kids_map" asset catalog image resource.
    static let kidsMap = DeveloperToolsSupport.ImageResource(name: "kids_map", bundle: resourceBundle)

    /// The "leaderboard_star" asset catalog image resource.
    static let leaderboardStar = DeveloperToolsSupport.ImageResource(name: "leaderboard_star", bundle: resourceBundle)

    /// The "link" asset catalog image resource.
    static let link = DeveloperToolsSupport.ImageResource(name: "link", bundle: resourceBundle)

    /// The "location_pin" asset catalog image resource.
    static let locationPin = DeveloperToolsSupport.ImageResource(name: "location_pin", bundle: resourceBundle)

    /// The "lock" asset catalog image resource.
    static let lock = DeveloperToolsSupport.ImageResource(name: "lock", bundle: resourceBundle)

    /// The "lock_open" asset catalog image resource.
    static let lockOpen = DeveloperToolsSupport.ImageResource(name: "lock_open", bundle: resourceBundle)

    /// The "logout" asset catalog image resource.
    static let logout = DeveloperToolsSupport.ImageResource(name: "logout", bundle: resourceBundle)

    /// The "low_battery" asset catalog image resource.
    static let lowBattery = DeveloperToolsSupport.ImageResource(name: "low_battery", bundle: resourceBundle)

    /// The "map_route_bg" asset catalog image resource.
    static let mapRouteBg = DeveloperToolsSupport.ImageResource(name: "map_route_bg", bundle: resourceBundle)

    /// The "marker" asset catalog image resource.
    static let marker = DeveloperToolsSupport.ImageResource(name: "marker", bundle: resourceBundle)

    /// The "members" asset catalog image resource.
    static let members = DeveloperToolsSupport.ImageResource(name: "members", bundle: resourceBundle)

    /// The "message_chat_heart" asset catalog image resource.
    static let messageChatHeart = DeveloperToolsSupport.ImageResource(name: "message_chat_heart", bundle: resourceBundle)

    /// The "messages" asset catalog image resource.
    static let messages = DeveloperToolsSupport.ImageResource(name: "messages", bundle: resourceBundle)

    /// The "new_massage_dot" asset catalog image resource.
    static let newMassageDot = DeveloperToolsSupport.ImageResource(name: "new_massage_dot", bundle: resourceBundle)

    /// The "notification_2" asset catalog image resource.
    static let notification2 = DeveloperToolsSupport.ImageResource(name: "notification_2", bundle: resourceBundle)

    /// The "notification_2_orange" asset catalog image resource.
    static let notification2Orange = DeveloperToolsSupport.ImageResource(name: "notification_2_orange", bundle: resourceBundle)

    /// The "pen" asset catalog image resource.
    static let pen = DeveloperToolsSupport.ImageResource(name: "pen", bundle: resourceBundle)

    /// The "pets" asset catalog image resource.
    static let pets = DeveloperToolsSupport.ImageResource(name: "pets", bundle: resourceBundle)

    /// The "phone_vibrate" asset catalog image resource.
    static let phoneVibrate = DeveloperToolsSupport.ImageResource(name: "phone_vibrate", bundle: resourceBundle)

    /// The "pin" asset catalog image resource.
    static let pin = DeveloperToolsSupport.ImageResource(name: "pin", bundle: resourceBundle)

    /// The "plus_circle" asset catalog image resource.
    static let plusCircle = DeveloperToolsSupport.ImageResource(name: "plus_circle", bundle: resourceBundle)

    /// The "question_mark_circle" asset catalog image resource.
    static let questionMarkCircle = DeveloperToolsSupport.ImageResource(name: "question_mark_circle", bundle: resourceBundle)

    /// The "refresh" asset catalog image resource.
    static let refresh = DeveloperToolsSupport.ImageResource(name: "refresh", bundle: resourceBundle)

    /// The "remove_battery" asset catalog image resource.
    static let removeBattery = DeveloperToolsSupport.ImageResource(name: "remove_battery", bundle: resourceBundle)

    /// The "ringing" asset catalog image resource.
    static let ringing = DeveloperToolsSupport.ImageResource(name: "ringing", bundle: resourceBundle)

    /// The "route_end_dot" asset catalog image resource.
    static let routeEndDot = DeveloperToolsSupport.ImageResource(name: "route_end_dot", bundle: resourceBundle)

    /// The "route_start_dot" asset catalog image resource.
    static let routeStartDot = DeveloperToolsSupport.ImageResource(name: "route_start_dot", bundle: resourceBundle)

    /// The "running_figure" asset catalog image resource.
    static let runningFigure = DeveloperToolsSupport.ImageResource(name: "running_figure", bundle: resourceBundle)

    /// The "safe_drive_illustration" asset catalog image resource.
    static let safeDriveIllustration = DeveloperToolsSupport.ImageResource(name: "safe_drive_illustration", bundle: resourceBundle)

    /// The "search" asset catalog image resource.
    static let search = DeveloperToolsSupport.ImageResource(name: "search", bundle: resourceBundle)

    /// The "setting" asset catalog image resource.
    static let setting = DeveloperToolsSupport.ImageResource(name: "setting", bundle: resourceBundle)

    /// The "share" asset catalog image resource.
    static let share = DeveloperToolsSupport.ImageResource(name: "share", bundle: resourceBundle)

    /// The "shield_done" asset catalog image resource.
    static let shieldDone = DeveloperToolsSupport.ImageResource(name: "shield_done", bundle: resourceBundle)

    /// The "shield_done_blue" asset catalog image resource.
    static let shieldDoneBlue = DeveloperToolsSupport.ImageResource(name: "shield_done_blue", bundle: resourceBundle)

    /// The "sleeping" asset catalog image resource.
    static let sleeping = DeveloperToolsSupport.ImageResource(name: "sleeping", bundle: resourceBundle)

    /// The "star_small" asset catalog image resource.
    static let starSmall = DeveloperToolsSupport.ImageResource(name: "star_small", bundle: resourceBundle)

    /// The "stopwatch_speed" asset catalog image resource.
    static let stopwatchSpeed = DeveloperToolsSupport.ImageResource(name: "stopwatch_speed", bundle: resourceBundle)

    /// The "store" asset catalog image resource.
    static let store = DeveloperToolsSupport.ImageResource(name: "store", bundle: resourceBundle)

    /// The "street_map" asset catalog image resource.
    static let streetMap = DeveloperToolsSupport.ImageResource(name: "street_map", bundle: resourceBundle)

    /// The "three_user" asset catalog image resource.
    static let threeUser = DeveloperToolsSupport.ImageResource(name: "three_user", bundle: resourceBundle)

    /// The "time_circle" asset catalog image resource.
    static let timeCircle = DeveloperToolsSupport.ImageResource(name: "time_circle", bundle: resourceBundle)

    /// The "turn_left" asset catalog image resource.
    static let turnLeft = DeveloperToolsSupport.ImageResource(name: "turn_left", bundle: resourceBundle)

    /// The "turn_right" asset catalog image resource.
    static let turnRight = DeveloperToolsSupport.ImageResource(name: "turn_right", bundle: resourceBundle)

    /// The "user_gem" asset catalog image resource.
    static let userGem = DeveloperToolsSupport.ImageResource(name: "user_gem", bundle: resourceBundle)

    /// The "warning_emoji" asset catalog image resource.
    static let warningEmoji = DeveloperToolsSupport.ImageResource(name: "warning_emoji", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "add_user" asset catalog image.
    static var addUser: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .addUser)
#else
        .init()
#endif
    }

    /// The "alerts" asset catalog image.
    static var alerts: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .alerts)
#else
        .init()
#endif
    }

    /// The "app_instagram" asset catalog image.
    static var appInstagram: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appInstagram)
#else
        .init()
#endif
    }

    /// The "app_pubg" asset catalog image.
    static var appPubg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appPubg)
#else
        .init()
#endif
    }

    /// The "app_tiktok" asset catalog image.
    static var appTiktok: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appTiktok)
#else
        .init()
#endif
    }

    /// The "app_youtube" asset catalog image.
    static var appYoutube: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appYoutube)
#else
        .init()
#endif
    }

    /// The "apple_logo" asset catalog image.
    static var appleLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appleLogo)
#else
        .init()
#endif
    }

    /// The "arrow_down" asset catalog image.
    static var arrowDown: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .arrowDown)
#else
        .init()
#endif
    }

    /// The "arrow_right" asset catalog image.
    static var arrowRight: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .arrowRight)
#else
        .init()
#endif
    }

    /// The "auto_satellite_map" asset catalog image.
    static var autoSatelliteMap: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .autoSatelliteMap)
#else
        .init()
#endif
    }

    /// The "avatar_chat_me" asset catalog image.
    static var avatarChatMe: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatarChatMe)
#else
        .init()
#endif
    }

    /// The "avatar_chat_other" asset catalog image.
    static var avatarChatOther: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatarChatOther)
#else
        .init()
#endif
    }

    /// The "avatar_fidan" asset catalog image.
    static var avatarFidan: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatarFidan)
#else
        .init()
#endif
    }

    /// The "avatar_fidan_chat" asset catalog image.
    static var avatarFidanChat: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatarFidanChat)
#else
        .init()
#endif
    }

    /// The "avatar_firuza" asset catalog image.
    static var avatarFiruza: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatarFiruza)
#else
        .init()
#endif
    }

    /// The "avatar_nigar" asset catalog image.
    static var avatarNigar: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatarNigar)
#else
        .init()
#endif
    }

    /// The "back_arrow" asset catalog image.
    static var backArrow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .backArrow)
#else
        .init()
#endif
    }

    /// The "cancle_outline" asset catalog image.
    static var cancleOutline: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cancleOutline)
#else
        .init()
#endif
    }

    /// The "car" asset catalog image.
    static var car: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .car)
#else
        .init()
#endif
    }

    /// The "car_filled" asset catalog image.
    static var carFilled: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .carFilled)
#else
        .init()
#endif
    }

    /// The "charge_battery" asset catalog image.
    static var chargeBattery: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chargeBattery)
#else
        .init()
#endif
    }

    /// The "chat" asset catalog image.
    static var chat: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chat)
#else
        .init()
#endif
    }

    /// The "chat_bubble_tail_left" asset catalog image.
    static var chatBubbleTailLeft: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatBubbleTailLeft)
#else
        .init()
#endif
    }

    /// The "chat_bubble_tail_right" asset catalog image.
    static var chatBubbleTailRight: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatBubbleTailRight)
#else
        .init()
#endif
    }

    /// The "chat_seen_check" asset catalog image.
    static var chatSeenCheck: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatSeenCheck)
#else
        .init()
#endif
    }

    /// The "chat_send_button" asset catalog image.
    static var chatSendButton: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatSendButton)
#else
        .init()
#endif
    }

    /// The "checkmark" asset catalog image.
    static var checkmark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .checkmark)
#else
        .init()
#endif
    }

    /// The "chevron_down" asset catalog image.
    static var chevronDown: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chevronDown)
#else
        .init()
#endif
    }

    /// The "circle_clock" asset catalog image.
    static var circleClock: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleClock)
#else
        .init()
#endif
    }

    /// The "circle_grid_interface" asset catalog image.
    static var circleGridInterface: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .circleGridInterface)
#else
        .init()
#endif
    }

    /// The "close_circle" asset catalog image.
    static var closeCircle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .closeCircle)
#else
        .init()
#endif
    }

    /// The "close_small" asset catalog image.
    static var closeSmall: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .closeSmall)
#else
        .init()
#endif
    }

    /// The "danger" asset catalog image.
    static var danger: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .danger)
#else
        .init()
#endif
    }

    /// The "diamond_star" asset catalog image.
    static var diamondStar: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .diamondStar)
#else
        .init()
#endif
    }

    /// The "earth" asset catalog image.
    static var earth: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .earth)
#else
        .init()
#endif
    }

    /// The "emoji_bell" asset catalog image.
    static var emojiBell: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiBell)
#else
        .init()
#endif
    }

    /// The "emoji_car" asset catalog image.
    static var emojiCar: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiCar)
#else
        .init()
#endif
    }

    /// The "emoji_chat_bubble" asset catalog image.
    static var emojiChatBubble: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiChatBubble)
#else
        .init()
#endif
    }

    /// The "emoji_clapping_hands" asset catalog image.
    static var emojiClappingHands: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiClappingHands)
#else
        .init()
#endif
    }

    /// The "emoji_clock_2" asset catalog image.
    static var emojiClock2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiClock2)
#else
        .init()
#endif
    }

    /// The "emoji_crown" asset catalog image.
    static var emojiCrown: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiCrown)
#else
        .init()
#endif
    }

    /// The "emoji_dog" asset catalog image.
    static var emojiDog: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiDog)
#else
        .init()
#endif
    }

    /// The "emoji_gift" asset catalog image.
    static var emojiGift: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiGift)
#else
        .init()
#endif
    }

    /// The "emoji_heart_red" asset catalog image.
    static var emojiHeartRed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiHeartRed)
#else
        .init()
#endif
    }

    /// The "emoji_listen" asset catalog image.
    static var emojiListen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiListen)
#else
        .init()
#endif
    }

    /// The "emoji_locked" asset catalog image.
    static var emojiLocked: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiLocked)
#else
        .init()
#endif
    }

    /// The "emoji_logout_3d" asset catalog image.
    static var emojiLogout3D: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiLogout3D)
#else
        .init()
#endif
    }

    /// The "emoji_megaphone" asset catalog image.
    static var emojiMegaphone: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiMegaphone)
#else
        .init()
#endif
    }

    /// The "emoji_open_envelope" asset catalog image.
    static var emojiOpenEnvelope: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiOpenEnvelope)
#else
        .init()
#endif
    }

    /// The "emoji_phone" asset catalog image.
    static var emojiPhone: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiPhone)
#else
        .init()
#endif
    }

    /// The "emoji_running" asset catalog image.
    static var emojiRunning: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiRunning)
#else
        .init()
#endif
    }

    /// The "emoji_screen_limit" asset catalog image.
    static var emojiScreenLimit: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiScreenLimit)
#else
        .init()
#endif
    }

    /// The "emoji_screenshot" asset catalog image.
    static var emojiScreenshot: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiScreenshot)
#else
        .init()
#endif
    }

    /// The "emoji_sharp_stop" asset catalog image.
    static var emojiSharpStop: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiSharpStop)
#else
        .init()
#endif
    }

    /// The "emoji_speech_bubbles" asset catalog image.
    static var emojiSpeechBubbles: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiSpeechBubbles)
#else
        .init()
#endif
    }

    /// The "emoji_speed" asset catalog image.
    static var emojiSpeed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiSpeed)
#else
        .init()
#endif
    }

    /// The "emoji_unlock" asset catalog image.
    static var emojiUnlock: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiUnlock)
#else
        .init()
#endif
    }

    /// The "emoji_warning" asset catalog image.
    static var emojiWarning: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiWarning)
#else
        .init()
#endif
    }

    /// The "emoji_warning_3d" asset catalog image.
    static var emojiWarning3D: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiWarning3D)
#else
        .init()
#endif
    }

    /// The "emoji_wave" asset catalog image.
    static var emojiWave: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emojiWave)
#else
        .init()
#endif
    }

    /// The "fire" asset catalog image.
    static var fire: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fire)
#else
        .init()
#endif
    }

    /// The "flash" asset catalog image.
    static var flash: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .flash)
#else
        .init()
#endif
    }

    /// The "frame" asset catalog image.
    static var frame: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .frame)
#else
        .init()
#endif
    }

    /// The "full_battery" asset catalog image.
    static var fullBattery: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fullBattery)
#else
        .init()
#endif
    }

    /// The "gem" asset catalog image.
    static var gem: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gem)
#else
        .init()
#endif
    }

    /// The "google_logo" asset catalog image.
    static var googleLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .googleLogo)
#else
        .init()
#endif
    }

    /// The "heart" asset catalog image.
    static var heart: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .heart)
#else
        .init()
#endif
    }

    /// The "heart_rate" asset catalog image.
    static var heartRate: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .heartRate)
#else
        .init()
#endif
    }

    /// The "home" asset catalog image.
    static var home: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .home)
#else
        .init()
#endif
    }

    /// The "journey" asset catalog image.
    static var journey: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .journey)
#else
        .init()
#endif
    }

    /// The "kids_map" asset catalog image.
    static var kidsMap: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .kidsMap)
#else
        .init()
#endif
    }

    /// The "leaderboard_star" asset catalog image.
    static var leaderboardStar: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .leaderboardStar)
#else
        .init()
#endif
    }

    /// The "link" asset catalog image.
    static var link: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .link)
#else
        .init()
#endif
    }

    /// The "location_pin" asset catalog image.
    static var locationPin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .locationPin)
#else
        .init()
#endif
    }

    /// The "lock" asset catalog image.
    static var lock: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lock)
#else
        .init()
#endif
    }

    /// The "lock_open" asset catalog image.
    static var lockOpen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lockOpen)
#else
        .init()
#endif
    }

    /// The "logout" asset catalog image.
    static var logout: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logout)
#else
        .init()
#endif
    }

    /// The "low_battery" asset catalog image.
    static var lowBattery: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lowBattery)
#else
        .init()
#endif
    }

    /// The "map_route_bg" asset catalog image.
    static var mapRouteBg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mapRouteBg)
#else
        .init()
#endif
    }

    /// The "marker" asset catalog image.
    static var marker: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .marker)
#else
        .init()
#endif
    }

    /// The "members" asset catalog image.
    static var members: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .members)
#else
        .init()
#endif
    }

    /// The "message_chat_heart" asset catalog image.
    static var messageChatHeart: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .messageChatHeart)
#else
        .init()
#endif
    }

    /// The "messages" asset catalog image.
    static var messages: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .messages)
#else
        .init()
#endif
    }

    /// The "new_massage_dot" asset catalog image.
    static var newMassageDot: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .newMassageDot)
#else
        .init()
#endif
    }

    /// The "notification_2" asset catalog image.
    static var notification2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .notification2)
#else
        .init()
#endif
    }

    /// The "notification_2_orange" asset catalog image.
    static var notification2Orange: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .notification2Orange)
#else
        .init()
#endif
    }

    /// The "pen" asset catalog image.
    static var pen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pen)
#else
        .init()
#endif
    }

    /// The "pets" asset catalog image.
    static var pets: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pets)
#else
        .init()
#endif
    }

    /// The "phone_vibrate" asset catalog image.
    static var phoneVibrate: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .phoneVibrate)
#else
        .init()
#endif
    }

    /// The "pin" asset catalog image.
    static var pin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pin)
#else
        .init()
#endif
    }

    /// The "plus_circle" asset catalog image.
    static var plusCircle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .plusCircle)
#else
        .init()
#endif
    }

    /// The "question_mark_circle" asset catalog image.
    static var questionMarkCircle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .questionMarkCircle)
#else
        .init()
#endif
    }

    /// The "refresh" asset catalog image.
    static var refresh: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .refresh)
#else
        .init()
#endif
    }

    /// The "remove_battery" asset catalog image.
    static var removeBattery: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .removeBattery)
#else
        .init()
#endif
    }

    /// The "ringing" asset catalog image.
    static var ringing: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ringing)
#else
        .init()
#endif
    }

    /// The "route_end_dot" asset catalog image.
    static var routeEndDot: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .routeEndDot)
#else
        .init()
#endif
    }

    /// The "route_start_dot" asset catalog image.
    static var routeStartDot: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .routeStartDot)
#else
        .init()
#endif
    }

    /// The "running_figure" asset catalog image.
    static var runningFigure: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .runningFigure)
#else
        .init()
#endif
    }

    /// The "safe_drive_illustration" asset catalog image.
    static var safeDriveIllustration: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .safeDriveIllustration)
#else
        .init()
#endif
    }

    /// The "search" asset catalog image.
    static var search: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .search)
#else
        .init()
#endif
    }

    /// The "setting" asset catalog image.
    static var setting: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .setting)
#else
        .init()
#endif
    }

    /// The "share" asset catalog image.
    static var share: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .share)
#else
        .init()
#endif
    }

    /// The "shield_done" asset catalog image.
    static var shieldDone: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shieldDone)
#else
        .init()
#endif
    }

    /// The "shield_done_blue" asset catalog image.
    static var shieldDoneBlue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shieldDoneBlue)
#else
        .init()
#endif
    }

    /// The "sleeping" asset catalog image.
    static var sleeping: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sleeping)
#else
        .init()
#endif
    }

    /// The "star_small" asset catalog image.
    static var starSmall: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .starSmall)
#else
        .init()
#endif
    }

    /// The "stopwatch_speed" asset catalog image.
    static var stopwatchSpeed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .stopwatchSpeed)
#else
        .init()
#endif
    }

    /// The "store" asset catalog image.
    static var store: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .store)
#else
        .init()
#endif
    }

    /// The "street_map" asset catalog image.
    static var streetMap: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .streetMap)
#else
        .init()
#endif
    }

    /// The "three_user" asset catalog image.
    static var threeUser: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .threeUser)
#else
        .init()
#endif
    }

    /// The "time_circle" asset catalog image.
    static var timeCircle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .timeCircle)
#else
        .init()
#endif
    }

    /// The "turn_left" asset catalog image.
    static var turnLeft: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .turnLeft)
#else
        .init()
#endif
    }

    /// The "turn_right" asset catalog image.
    static var turnRight: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .turnRight)
#else
        .init()
#endif
    }

    /// The "user_gem" asset catalog image.
    static var userGem: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .userGem)
#else
        .init()
#endif
    }

    /// The "warning_emoji" asset catalog image.
    static var warningEmoji: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .warningEmoji)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "add_user" asset catalog image.
    static var addUser: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .addUser)
#else
        .init()
#endif
    }

    /// The "alerts" asset catalog image.
    static var alerts: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .alerts)
#else
        .init()
#endif
    }

    /// The "app_instagram" asset catalog image.
    static var appInstagram: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appInstagram)
#else
        .init()
#endif
    }

    /// The "app_pubg" asset catalog image.
    static var appPubg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appPubg)
#else
        .init()
#endif
    }

    /// The "app_tiktok" asset catalog image.
    static var appTiktok: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appTiktok)
#else
        .init()
#endif
    }

    /// The "app_youtube" asset catalog image.
    static var appYoutube: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appYoutube)
#else
        .init()
#endif
    }

    /// The "apple_logo" asset catalog image.
    static var appleLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appleLogo)
#else
        .init()
#endif
    }

    /// The "arrow_down" asset catalog image.
    static var arrowDown: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .arrowDown)
#else
        .init()
#endif
    }

    /// The "arrow_right" asset catalog image.
    static var arrowRight: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .arrowRight)
#else
        .init()
#endif
    }

    /// The "auto_satellite_map" asset catalog image.
    static var autoSatelliteMap: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .autoSatelliteMap)
#else
        .init()
#endif
    }

    /// The "avatar_chat_me" asset catalog image.
    static var avatarChatMe: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatarChatMe)
#else
        .init()
#endif
    }

    /// The "avatar_chat_other" asset catalog image.
    static var avatarChatOther: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatarChatOther)
#else
        .init()
#endif
    }

    /// The "avatar_fidan" asset catalog image.
    static var avatarFidan: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatarFidan)
#else
        .init()
#endif
    }

    /// The "avatar_fidan_chat" asset catalog image.
    static var avatarFidanChat: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatarFidanChat)
#else
        .init()
#endif
    }

    /// The "avatar_firuza" asset catalog image.
    static var avatarFiruza: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatarFiruza)
#else
        .init()
#endif
    }

    /// The "avatar_nigar" asset catalog image.
    static var avatarNigar: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatarNigar)
#else
        .init()
#endif
    }

    /// The "back_arrow" asset catalog image.
    static var backArrow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .backArrow)
#else
        .init()
#endif
    }

    /// The "cancle_outline" asset catalog image.
    static var cancleOutline: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cancleOutline)
#else
        .init()
#endif
    }

    /// The "car" asset catalog image.
    static var car: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .car)
#else
        .init()
#endif
    }

    /// The "car_filled" asset catalog image.
    static var carFilled: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .carFilled)
#else
        .init()
#endif
    }

    /// The "charge_battery" asset catalog image.
    static var chargeBattery: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chargeBattery)
#else
        .init()
#endif
    }

    /// The "chat" asset catalog image.
    static var chat: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chat)
#else
        .init()
#endif
    }

    /// The "chat_bubble_tail_left" asset catalog image.
    static var chatBubbleTailLeft: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatBubbleTailLeft)
#else
        .init()
#endif
    }

    /// The "chat_bubble_tail_right" asset catalog image.
    static var chatBubbleTailRight: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatBubbleTailRight)
#else
        .init()
#endif
    }

    /// The "chat_seen_check" asset catalog image.
    static var chatSeenCheck: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatSeenCheck)
#else
        .init()
#endif
    }

    /// The "chat_send_button" asset catalog image.
    static var chatSendButton: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatSendButton)
#else
        .init()
#endif
    }

    #warning("The \"checkmark\" image asset name resolves to a conflicting UIImage symbol \"checkmark\". Try renaming the asset.")

    /// The "chevron_down" asset catalog image.
    static var chevronDown: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chevronDown)
#else
        .init()
#endif
    }

    /// The "circle_clock" asset catalog image.
    static var circleClock: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleClock)
#else
        .init()
#endif
    }

    /// The "circle_grid_interface" asset catalog image.
    static var circleGridInterface: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .circleGridInterface)
#else
        .init()
#endif
    }

    /// The "close_circle" asset catalog image.
    static var closeCircle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .closeCircle)
#else
        .init()
#endif
    }

    /// The "close_small" asset catalog image.
    static var closeSmall: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .closeSmall)
#else
        .init()
#endif
    }

    /// The "danger" asset catalog image.
    static var danger: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .danger)
#else
        .init()
#endif
    }

    /// The "diamond_star" asset catalog image.
    static var diamondStar: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .diamondStar)
#else
        .init()
#endif
    }

    /// The "earth" asset catalog image.
    static var earth: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .earth)
#else
        .init()
#endif
    }

    /// The "emoji_bell" asset catalog image.
    static var emojiBell: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiBell)
#else
        .init()
#endif
    }

    /// The "emoji_car" asset catalog image.
    static var emojiCar: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiCar)
#else
        .init()
#endif
    }

    /// The "emoji_chat_bubble" asset catalog image.
    static var emojiChatBubble: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiChatBubble)
#else
        .init()
#endif
    }

    /// The "emoji_clapping_hands" asset catalog image.
    static var emojiClappingHands: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiClappingHands)
#else
        .init()
#endif
    }

    /// The "emoji_clock_2" asset catalog image.
    static var emojiClock2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiClock2)
#else
        .init()
#endif
    }

    /// The "emoji_crown" asset catalog image.
    static var emojiCrown: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiCrown)
#else
        .init()
#endif
    }

    /// The "emoji_dog" asset catalog image.
    static var emojiDog: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiDog)
#else
        .init()
#endif
    }

    /// The "emoji_gift" asset catalog image.
    static var emojiGift: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiGift)
#else
        .init()
#endif
    }

    /// The "emoji_heart_red" asset catalog image.
    static var emojiHeartRed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiHeartRed)
#else
        .init()
#endif
    }

    /// The "emoji_listen" asset catalog image.
    static var emojiListen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiListen)
#else
        .init()
#endif
    }

    /// The "emoji_locked" asset catalog image.
    static var emojiLocked: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiLocked)
#else
        .init()
#endif
    }

    /// The "emoji_logout_3d" asset catalog image.
    static var emojiLogout3D: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiLogout3D)
#else
        .init()
#endif
    }

    /// The "emoji_megaphone" asset catalog image.
    static var emojiMegaphone: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiMegaphone)
#else
        .init()
#endif
    }

    /// The "emoji_open_envelope" asset catalog image.
    static var emojiOpenEnvelope: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiOpenEnvelope)
#else
        .init()
#endif
    }

    /// The "emoji_phone" asset catalog image.
    static var emojiPhone: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiPhone)
#else
        .init()
#endif
    }

    /// The "emoji_running" asset catalog image.
    static var emojiRunning: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiRunning)
#else
        .init()
#endif
    }

    /// The "emoji_screen_limit" asset catalog image.
    static var emojiScreenLimit: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiScreenLimit)
#else
        .init()
#endif
    }

    /// The "emoji_screenshot" asset catalog image.
    static var emojiScreenshot: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiScreenshot)
#else
        .init()
#endif
    }

    /// The "emoji_sharp_stop" asset catalog image.
    static var emojiSharpStop: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiSharpStop)
#else
        .init()
#endif
    }

    /// The "emoji_speech_bubbles" asset catalog image.
    static var emojiSpeechBubbles: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiSpeechBubbles)
#else
        .init()
#endif
    }

    /// The "emoji_speed" asset catalog image.
    static var emojiSpeed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiSpeed)
#else
        .init()
#endif
    }

    /// The "emoji_unlock" asset catalog image.
    static var emojiUnlock: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiUnlock)
#else
        .init()
#endif
    }

    /// The "emoji_warning" asset catalog image.
    static var emojiWarning: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiWarning)
#else
        .init()
#endif
    }

    /// The "emoji_warning_3d" asset catalog image.
    static var emojiWarning3D: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiWarning3D)
#else
        .init()
#endif
    }

    /// The "emoji_wave" asset catalog image.
    static var emojiWave: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emojiWave)
#else
        .init()
#endif
    }

    /// The "fire" asset catalog image.
    static var fire: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fire)
#else
        .init()
#endif
    }

    /// The "flash" asset catalog image.
    static var flash: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .flash)
#else
        .init()
#endif
    }

    /// The "frame" asset catalog image.
    static var frame: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .frame)
#else
        .init()
#endif
    }

    /// The "full_battery" asset catalog image.
    static var fullBattery: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fullBattery)
#else
        .init()
#endif
    }

    /// The "gem" asset catalog image.
    static var gem: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gem)
#else
        .init()
#endif
    }

    /// The "google_logo" asset catalog image.
    static var googleLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .googleLogo)
#else
        .init()
#endif
    }

    /// The "heart" asset catalog image.
    static var heart: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .heart)
#else
        .init()
#endif
    }

    /// The "heart_rate" asset catalog image.
    static var heartRate: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .heartRate)
#else
        .init()
#endif
    }

    /// The "home" asset catalog image.
    static var home: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .home)
#else
        .init()
#endif
    }

    /// The "journey" asset catalog image.
    static var journey: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .journey)
#else
        .init()
#endif
    }

    /// The "kids_map" asset catalog image.
    static var kidsMap: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .kidsMap)
#else
        .init()
#endif
    }

    /// The "leaderboard_star" asset catalog image.
    static var leaderboardStar: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .leaderboardStar)
#else
        .init()
#endif
    }

    /// The "link" asset catalog image.
    static var link: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .link)
#else
        .init()
#endif
    }

    /// The "location_pin" asset catalog image.
    static var locationPin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .locationPin)
#else
        .init()
#endif
    }

    /// The "lock" asset catalog image.
    static var lock: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lock)
#else
        .init()
#endif
    }

    /// The "lock_open" asset catalog image.
    static var lockOpen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lockOpen)
#else
        .init()
#endif
    }

    /// The "logout" asset catalog image.
    static var logout: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logout)
#else
        .init()
#endif
    }

    /// The "low_battery" asset catalog image.
    static var lowBattery: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lowBattery)
#else
        .init()
#endif
    }

    /// The "map_route_bg" asset catalog image.
    static var mapRouteBg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mapRouteBg)
#else
        .init()
#endif
    }

    /// The "marker" asset catalog image.
    static var marker: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .marker)
#else
        .init()
#endif
    }

    /// The "members" asset catalog image.
    static var members: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .members)
#else
        .init()
#endif
    }

    /// The "message_chat_heart" asset catalog image.
    static var messageChatHeart: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .messageChatHeart)
#else
        .init()
#endif
    }

    /// The "messages" asset catalog image.
    static var messages: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .messages)
#else
        .init()
#endif
    }

    /// The "new_massage_dot" asset catalog image.
    static var newMassageDot: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .newMassageDot)
#else
        .init()
#endif
    }

    /// The "notification_2" asset catalog image.
    static var notification2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .notification2)
#else
        .init()
#endif
    }

    /// The "notification_2_orange" asset catalog image.
    static var notification2Orange: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .notification2Orange)
#else
        .init()
#endif
    }

    /// The "pen" asset catalog image.
    static var pen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pen)
#else
        .init()
#endif
    }

    /// The "pets" asset catalog image.
    static var pets: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pets)
#else
        .init()
#endif
    }

    /// The "phone_vibrate" asset catalog image.
    static var phoneVibrate: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .phoneVibrate)
#else
        .init()
#endif
    }

    /// The "pin" asset catalog image.
    static var pin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pin)
#else
        .init()
#endif
    }

    /// The "plus_circle" asset catalog image.
    static var plusCircle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .plusCircle)
#else
        .init()
#endif
    }

    /// The "question_mark_circle" asset catalog image.
    static var questionMarkCircle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .questionMarkCircle)
#else
        .init()
#endif
    }

    /// The "refresh" asset catalog image.
    static var refresh: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .refresh)
#else
        .init()
#endif
    }

    /// The "remove_battery" asset catalog image.
    static var removeBattery: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .removeBattery)
#else
        .init()
#endif
    }

    /// The "ringing" asset catalog image.
    static var ringing: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ringing)
#else
        .init()
#endif
    }

    /// The "route_end_dot" asset catalog image.
    static var routeEndDot: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .routeEndDot)
#else
        .init()
#endif
    }

    /// The "route_start_dot" asset catalog image.
    static var routeStartDot: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .routeStartDot)
#else
        .init()
#endif
    }

    /// The "running_figure" asset catalog image.
    static var runningFigure: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .runningFigure)
#else
        .init()
#endif
    }

    /// The "safe_drive_illustration" asset catalog image.
    static var safeDriveIllustration: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .safeDriveIllustration)
#else
        .init()
#endif
    }

    /// The "search" asset catalog image.
    static var search: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .search)
#else
        .init()
#endif
    }

    /// The "setting" asset catalog image.
    static var setting: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .setting)
#else
        .init()
#endif
    }

    /// The "share" asset catalog image.
    static var share: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .share)
#else
        .init()
#endif
    }

    /// The "shield_done" asset catalog image.
    static var shieldDone: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shieldDone)
#else
        .init()
#endif
    }

    /// The "shield_done_blue" asset catalog image.
    static var shieldDoneBlue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shieldDoneBlue)
#else
        .init()
#endif
    }

    /// The "sleeping" asset catalog image.
    static var sleeping: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sleeping)
#else
        .init()
#endif
    }

    /// The "star_small" asset catalog image.
    static var starSmall: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .starSmall)
#else
        .init()
#endif
    }

    /// The "stopwatch_speed" asset catalog image.
    static var stopwatchSpeed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .stopwatchSpeed)
#else
        .init()
#endif
    }

    /// The "store" asset catalog image.
    static var store: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .store)
#else
        .init()
#endif
    }

    /// The "street_map" asset catalog image.
    static var streetMap: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .streetMap)
#else
        .init()
#endif
    }

    /// The "three_user" asset catalog image.
    static var threeUser: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .threeUser)
#else
        .init()
#endif
    }

    /// The "time_circle" asset catalog image.
    static var timeCircle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .timeCircle)
#else
        .init()
#endif
    }

    /// The "turn_left" asset catalog image.
    static var turnLeft: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .turnLeft)
#else
        .init()
#endif
    }

    /// The "turn_right" asset catalog image.
    static var turnRight: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .turnRight)
#else
        .init()
#endif
    }

    /// The "user_gem" asset catalog image.
    static var userGem: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .userGem)
#else
        .init()
#endif
    }

    /// The "warning_emoji" asset catalog image.
    static var warningEmoji: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .warningEmoji)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

