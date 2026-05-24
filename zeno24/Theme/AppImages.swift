import Foundation

/// PNG image asset names — 1:1 mirror of lib/core/config/constants/app_images.dart.
/// All assets live in `Assets.xcassets/Images/` and are looked up by the
/// file's basename (e.g. `emoji_clapping_hands.png` → `"emoji_clapping_hands"`).
///
/// Usage: `Image(AppImages.emojiCrown)`
enum AppImages {
    // MARK: Auth / generic emojis
    static let emojiClappingHands = "emoji_clapping_hands"
    static let emojiSpeechBubbles = "emoji_speech_bubbles"
    static let emojiOpenEnvelope  = "emoji_open_envelope"
    static let emojiDog           = "emoji_dog"
    static let emojiCrown         = "emoji_crown"
    static let emojiWarning       = "emoji_warning"
    static let emojiWarning3d     = "emoji_warning_3d"
    static let emojiGift          = "emoji_gift"
    static let emojiBell          = "emoji_bell"
    static let emojiLocked        = "emoji_locked"
    static let emojiLogout3d      = "emoji_logout_3d"
    static let emojiHeartRed      = "emoji_heart_red"
    static let emojiChatBubble    = "emoji_chat_bubble"
    static let emojiPhone         = "emoji_phone"
    static let emojiWave          = "emoji_wave"
    static let emojiMegaphone     = "emoji_megaphone"

    // MARK: Map / route
    static let autoSatelliteMap   = "auto_satellite_map"
    static let streetMap          = "street_map"
    static let mapRouteBg         = "map_route_bg"

    // MARK: Driving / Health
    static let runningFigure      = "running_figure"
    static let emojiSpeed         = "emoji_speed"
    static let emojiCar           = "emoji_car"
    static let emojiRunning       = "emoji_running"
    static let emojiClock2        = "emoji_clock_2"
    static let safeDriveIllustration = "safe_drive_illustration"
    static let emojiSharpStop     = "emoji_sharp_stop"

    // MARK: Avatars
    static let avatarNigar        = "avatar_nigar"
    static let avatarFiruza       = "avatar_firuza"
    static let avatarFidan        = "avatar_fidan"
    static let avatarFidanChat    = "avatar_fidan_chat"
    static let avatarChatMe       = "avatar_chat_me"
    static let avatarChatOther    = "avatar_chat_other"

    // MARK: Kids
    static let emojiScreenshot    = "emoji_screenshot"
    static let emojiListen        = "emoji_listen"
    static let emojiScreenLimit   = "emoji_screen_limit"
    static let emojiUnlock        = "emoji_unlock"
    static let kidsMap            = "kids_map"
    static let appPubg            = "app_pubg"
    static let appInstagram       = "app_instagram"
    static let appYoutube         = "app_youtube"
    static let appTiktok          = "app_tiktok"
}
