import Foundation

/// Type-safe accessors for every user-facing string in the app.
///
/// Each property pulls from `Localizable.xcstrings` via
/// `String(localized:)`. Add new entries here, then let Xcode auto-extract
/// the keys into the String Catalog when you build.
///
/// Mirrors Flutter's `AppLocalizations.of(context)!.continueKey` pattern,
/// but type-safe so renames break the build.
enum AppStrings {

    // MARK: Common

    enum Common {
        static var `continue`: String { String(localized: "common.continue", defaultValue: "Continue") }
        static var finish: String     { String(localized: "common.finish",   defaultValue: "Finish") }
        static var cancel: String     { String(localized: "common.cancel",   defaultValue: "Cancel") }
        static var back: String       { String(localized: "common.back",     defaultValue: "Back") }
        static var search: String     { String(localized: "common.search",   defaultValue: "Search") }
        static var or: String         { String(localized: "common.or",       defaultValue: "or continue with") }
    }

    // MARK: Brand

    enum Brand {
        static var name: String { String(localized: "brand.name", defaultValue: "Zeno24") }
    }

    // MARK: Onboarding

    enum Onboard {
        static var slide1: String {
            String(localized: "onboard.slide.1",
                   defaultValue: "Share your location with\nyour loved ones")
        }
        static var slide2: String {
            String(localized: "onboard.slide.2",
                   defaultValue: "Stay connected with\nthe ones who matter")
        }
        static var slide3: String {
            String(localized: "onboard.slide.3",
                   defaultValue: "Drive safely, together,\nin real time")
        }
        static var useEmailOrWhatsapp: String {
            String(localized: "onboard.cta", defaultValue: "Use email or Whatsapp")
        }

        enum Terms {
            static var prefix: String {
                String(localized: "onboard.terms.prefix",
                       defaultValue: "By clicking the buttons above you accept our")
            }
            static var privacy: String {
                String(localized: "onboard.terms.privacy", defaultValue: "Privacy Policy")
            }
            static var and: String {
                String(localized: "onboard.terms.and", defaultValue: " and ")
            }
            static var service: String {
                String(localized: "onboard.terms.service", defaultValue: "Terms of Service.")
            }
        }
    }

    // MARK: Auth

    enum Auth {
        enum SignIn {
            static var titlePhone: String {
                String(localized: "auth.signin.title.phone",
                       defaultValue: "Enter your phone number")
            }
            static var titleEmail: String {
                String(localized: "auth.signin.title.email",
                       defaultValue: "Enter your email")
            }
            static var subtitle: String {
                String(localized: "auth.signin.subtitle", defaultValue: "to get started")
            }
            static var emailHint: String {
                String(localized: "auth.signin.email.hint", defaultValue: "example@mail.com")
            }
        }

        enum Toggle {
            static var dontHaveWhatsapp: String {
                String(localized: "auth.toggle.dont_have_whatsapp",
                       defaultValue: "Don't have WhatsApp?")
            }
            static var dontHaveEmail: String {
                String(localized: "auth.toggle.dont_have_email",
                       defaultValue: "Don't have Email?")
            }
            static var useEmail: String {
                String(localized: "auth.toggle.use_email", defaultValue: "Use email")
            }
            static var useWhatsapp: String {
                String(localized: "auth.toggle.use_whatsapp", defaultValue: "Whatsapp")
            }
        }

        enum Otp {
            static var welcomeBack: String {
                String(localized: "auth.otp.welcome_back", defaultValue: "Welcome back!")
            }
            static var checkYourEmail: String {
                String(localized: "auth.otp.check_email", defaultValue: "Check your email")
            }
            static var checkYourWhatsapp: String {
                String(localized: "auth.otp.check_whatsapp", defaultValue: "Check your WhatsApp")
            }
            static var incorrect: String {
                String(localized: "auth.otp.incorrect",
                       defaultValue: "Incorrect verification code")
            }
            static var didntReceive: String {
                String(localized: "auth.otp.didnt_receive",
                       defaultValue: "Haven't received the code?")
            }
            static var resend: String {
                String(localized: "auth.otp.resend", defaultValue: "Resend")
            }
        }

        enum CreateName {
            static var title: String {
                String(localized: "auth.create_name.title", defaultValue: "You look new here")
            }
            static var subtitle: String {
                String(localized: "auth.create_name.subtitle",
                       defaultValue: "What should we call you?")
            }
            static var placeholder: String {
                String(localized: "auth.create_name.placeholder",
                       defaultValue: "Enter your name")
            }
        }

        enum Social {
            static var apple: String  { String(localized: "auth.social.apple",  defaultValue: "Apple") }
            static var google: String { String(localized: "auth.social.google", defaultValue: "Google") }
            static var continueWithGoogle: String {
                String(localized: "auth.social.continue_google", defaultValue: "Continue with Google")
            }
        }
    }

    // MARK: Country picker

    enum CountryPicker {
        static var title: String {
            String(localized: "country.title", defaultValue: "Choose Country")
        }
        static var search: String {
            String(localized: "country.search", defaultValue: "Search")
        }
        static var popular: String {
            String(localized: "country.popular", defaultValue: "★ Popular")
        }
        static var emptyTitle: String {
            String(localized: "country.empty.title", defaultValue: "No country found")
        }
        static var emptySubtitle: String {
            String(localized: "country.empty.subtitle",
                   defaultValue: "Try a different name or code")
        }
    }

    // MARK: Tabs

    enum Tab {
        static var home: String          { String(localized: "tab.home",          defaultValue: "Home") }
        static var kids: String          { String(localized: "tab.kids",          defaultValue: "Kids") }
        static var driving: String       { String(localized: "tab.driving",       defaultValue: "Driving") }
        static var health: String        { String(localized: "tab.health",        defaultValue: "Health") }
        static var premium: String       { String(localized: "tab.premium",       defaultValue: "Premium") }
        static var messages: String      { String(localized: "tab.messages",      defaultValue: "Messages") }
        static var notifications: String { String(localized: "tab.notifications", defaultValue: "Notifications") }
        static var profile: String       { String(localized: "tab.profile",       defaultValue: "Profile") }
        static var settings: String      { String(localized: "tab.settings",      defaultValue: "Settings") }
    }

    // MARK: Misc screens

    enum Home {
        static var panelTitle: String {
            String(localized: "home.panel.title", defaultValue: "Your circle")
        }
        static var members: String  { String(localized: "home.members",  defaultValue: "Members") }
        static var places: String   { String(localized: "home.places",   defaultValue: "Places") }
        static var pets: String     { String(localized: "home.pets",     defaultValue: "Pets") }
        static var alerts: String   { String(localized: "home.alerts",   defaultValue: "Alerts") }
        static var since: String    { String(localized: "home.since",    defaultValue: "Since:") }
        static var today: String    { String(localized: "home.today",    defaultValue: "Today") }
        static var yesterday: String { String(localized: "home.yesterday", defaultValue: "Yesterday") }
        static var unknownMember: String {
            String(localized: "home.unknown_member", defaultValue: "Unknown")
        }
        static var activityDriving: String { String(localized: "home.activity.driving", defaultValue: "Driving") }
        static var activityWalking: String { String(localized: "home.activity.walking", defaultValue: "Walking") }
        static var activityRunning: String { String(localized: "home.activity.running", defaultValue: "Running") }
        static var activityStill: String   { String(localized: "home.activity.still",   defaultValue: "At rest") }
        static var activityAtLocation: String {
            String(localized: "home.activity.at_location", defaultValue: "At location")
        }
        static var justNow: String { String(localized: "home.just_now", defaultValue: "Just now") }

        // Places tab
        static var placesTitle: String {
            String(localized: "home.places.title", defaultValue: "Places")
        }
        static var expandCircle: String {
            String(localized: "home.expand_circle", defaultValue: "Expand circle")
        }
        static var inviteNewMember: String {
            String(localized: "home.invite_new_member", defaultValue: "Invite a new member")
        }
        static var managePlaces: String {
            String(localized: "home.manage_places", defaultValue: "Manage Places")
        }
        static var managePlacesSubtitle: String {
            String(localized: "home.manage_places.subtitle",
                   defaultValue: "Get alerts for arrivals and departures.")
        }

        // Pets tab
        static var petsTitle: String {
            String(localized: "home.pets.title", defaultValue: "Pets")
        }
        static var petsHeadline: String {
            String(localized: "home.pets.headline", defaultValue: "Protect your furry friends")
        }
        static var petsSubheadline: String {
            String(localized: "home.pets.subheadline", defaultValue: "Start tracking now!")
        }
        static var petsCTA: String {
            String(localized: "home.pets.cta", defaultValue: "Pair now")
        }
        static var newBadge: String {
            String(localized: "home.new_badge", defaultValue: "NEW")
        }

        // Alerts tab
        static var alertsHeader: String {
            String(localized: "home.alerts.header", defaultValue: "Alerts & notifications")
        }
        static var alertPlaceAlerts: String {
            String(localized: "home.alerts.place", defaultValue: "Place alerts")
        }
        static var alertStartMovement: String {
            String(localized: "home.alerts.start_movement", defaultValue: "Start of Movement")
        }
        static var alertEndMovement: String {
            String(localized: "home.alerts.end_movement", defaultValue: "End of Movement")
        }
        static var alertSafeDrive: String {
            String(localized: "home.alerts.safe_drive", defaultValue: "Safe drive notifications")
        }
        static var alertLowBattery: String {
            String(localized: "home.alerts.low_battery", defaultValue: "Low battery")
        }

        // Premium promo
        static var premiumTitle: String {
            String(localized: "home.premium.title", defaultValue: "Unlock for\nPremium")
        }
        static var premiumFeature1: String {
            String(localized: "home.premium.f1",
                   defaultValue: "Manage screen time, app usage, and daily activity with ease.")
        }
        static var premiumFeature2: String {
            String(localized: "home.premium.f2",
                   defaultValue: "Track health-related insights and stay informed with timely alerts.")
        }
        static var premiumFeature3: String {
            String(localized: "home.premium.f3",
                   defaultValue: "Track health-related insights and stay informed with timely alerts.")
        }
        static var premiumFeature4: String {
            String(localized: "home.premium.f4",
                   defaultValue: "Parental Control Lorem ipsum dolor")
        }
        static var premiumCTA: String {
            String(localized: "home.premium.cta", defaultValue: "Start 7-day free trial")
        }
    }

    enum Chat {
        static var title: String       { String(localized: "chat.title",       defaultValue: "Chat") }
        static var placeholder: String { String(localized: "chat.placeholder", defaultValue: "Type a message") }
    }

    enum Profile {
        static var settings: String { String(localized: "profile.settings", defaultValue: "Settings") }
        static var premium: String  { String(localized: "profile.premium",  defaultValue: "Premium") }
        static var logout: String   { String(localized: "profile.logout",   defaultValue: "Log out") }
        static var logoutConfirmTitle: String {
            String(localized: "profile.logout.confirm.title", defaultValue: "Log out?")
        }
        static var logoutConfirmMessage: String {
            String(localized: "profile.logout.confirm.message",
                   defaultValue: "You'll need to sign in again to access your account.")
        }
        static var cancel: String   { String(localized: "common.cancel",    defaultValue: "Cancel") }
    }

    enum Settings {
        static var language: String   { String(localized: "settings.language",   defaultValue: "Language") }
        static var appearance: String { String(localized: "settings.appearance", defaultValue: "Appearance") }
        static var theme: String      { String(localized: "settings.theme",      defaultValue: "Theme") }
        static var logout: String     { String(localized: "settings.logout",     defaultValue: "Log out") }
    }

    enum Premium {
        static var title: String    { String(localized: "premium.title",    defaultValue: "Go Premium") }
        static var subtitle: String { String(localized: "premium.subtitle", defaultValue: "Unlock everything") }
        static var cta: String      { String(localized: "premium.cta",      defaultValue: "Start free trial") }
    }

    enum Health { static var title: String { String(localized: "health.title", defaultValue: "Health") } }
    enum Kids    { static var title: String { String(localized: "kids.title",    defaultValue: "Kids") } }
    enum Driving { static var title: String { String(localized: "driving.title", defaultValue: "Driving") } }

    // MARK: Units

    enum Units {
        static var kmh: String { String(localized: "units.kmh", defaultValue: "km/h") }
    }
}
