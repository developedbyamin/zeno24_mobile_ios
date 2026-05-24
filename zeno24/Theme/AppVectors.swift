import Foundation

/// SVG vector asset names — 1:1 mirror of lib/core/config/constants/app_icons.dart's `AppVectors`.
/// All assets live in `Assets.xcassets/Vectors/` and are configured with
/// `preserves-vector-representation = true` so they scale and tint cleanly.
///
/// Usage:
///   Image(AppVectors.appleLogo)              // raw asset
///   Image(AppVectors.appleLogo)              //  templated — apply .foregroundStyle
///       .renderingMode(.template)
enum AppVectors {
    // MARK: Generic
    static let backArrow          = "back_arrow"
    static let appleLogo          = "apple_logo"
    static let googleLogo         = "google_logo"
    static let warningEmoji       = "warning_emoji"
    static let arrowDown          = "arrow_down"
    static let arrowRight         = "arrow_right"
    static let search             = "search"
    static let closeSmall         = "close_small"
    static let closeCircle        = "close_circle"
    static let cancleOutline      = "cancle_outline"   // sic — matches Flutter typo
    static let checkmark          = "checkmark"
    static let chevronDown        = "chevron_down"
    static let refresh            = "refresh"
    static let plusCircle         = "plus_circle"
    static let pen                = "pen"
    static let share              = "share"
    static let link               = "link"
    static let logout             = "logout"
    static let questionMarkCircle = "question_mark_circle"

    // MARK: Status / battery
    static let alerts             = "alerts"
    static let chargeBattery      = "charge_battery"
    static let fullBattery        = "full_battery"
    static let lowBattery         = "low_battery"
    static let removeBattery      = "remove_battery"
    static let shieldDone         = "shield_done"
    static let shieldDoneBlue     = "shield_done_blue"
    static let danger             = "danger"
    static let fire               = "fire"
    static let flash              = "flash"

    // MARK: Tabs / nav
    static let home               = "home"
    static let messages           = "messages"
    static let setting            = "setting"
    static let members            = "members"
    static let store              = "store"
    static let notification2      = "notification_2"
    static let notification2Orange = "notification_2_orange"

    // MARK: Map / route
    static let marker             = "marker"
    static let pin                = "pin"
    static let locationPin        = "location_pin"
    static let earth              = "earth"
    static let frame              = "frame"
    static let journey            = "journey"
    static let routeStartDot      = "route_start_dot"
    static let routeEndDot        = "route_end_dot"
    static let turnLeft           = "turn_left"
    static let turnRight          = "turn_right"

    // MARK: Driving / Health
    static let car                = "car"
    static let carFilled          = "car_filled"
    static let stopwatchSpeed     = "stopwatch_speed"
    static let heart              = "heart"
    static let heartRate          = "heart_rate"
    static let sleeping           = "sleeping"
    static let phoneVibrate       = "phone_vibrate"
    static let ringing            = "ringing"
    static let starSmall          = "star_small"
    static let leaderboardStar    = "leaderboard_star"
    static let lock               = "lock"
    static let lockOpen           = "lock_open"
    static let circleClock        = "circle_clock"
    static let circleGridInterface = "circle_grid_interface"
    static let timeCircle         = "time_circle"

    // MARK: Profile / settings
    static let threeUser          = "three_user"
    static let messageChatHeart   = "message_chat_heart"

    // MARK: Chat
    static let chat               = "chat"
    static let chatSeenCheck      = "chat_seen_check"
    static let chatSendButton     = "chat_send_button"
    static let chatBubbleTailLeft = "chat_bubble_tail_left"
    static let chatBubbleTailRight = "chat_bubble_tail_right"
    static let newMassageDot      = "new_massage_dot"

    // MARK: Misc
    static let addUser            = "add_user"
    static let userGem            = "user_gem"
    static let gem                = "gem"
    static let diamondStar        = "diamond_star"
    static let pets               = "pets"

    // MARK: Kids apps
    static let appInstagram       = "app_instagram"
    static let appTiktok          = "app_tiktok"
    static let appYoutube         = "app_youtube"
}
