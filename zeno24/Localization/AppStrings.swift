import Foundation

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
            static var continueWithApple: String {
                String(localized: "auth.social.continue_apple", defaultValue: "Continue with Apple")
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
        static var placeholder: String { String(localized: "chat.placeholder", defaultValue: "Write a message") }
        static var quickLoveYou: String { String(localized: "chat.quick.loveYou", defaultValue: "Love you") }
        static var quickSayHello: String { String(localized: "chat.quick.sayHello", defaultValue: "Say Hello") }
        static var quickWriteMe: String { String(localized: "chat.quick.writeMe", defaultValue: "Write me") }
        static var quickCallMe: String { String(localized: "chat.quick.callMe", defaultValue: "Call me") }
        static var defaultCircle: String { String(localized: "chat.defaultCircle", defaultValue: "Family") }
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
        static var title: String      { String(localized: "settings.title",      defaultValue: "Profile") }
        static var language: String   { String(localized: "settings.language",   defaultValue: "Language") }
        static var appearance: String { String(localized: "settings.appearance", defaultValue: "Appearance") }
        static var theme: String      { String(localized: "settings.theme",      defaultValue: "Theme") }
        static var logout: String     { String(localized: "settings.logout",     defaultValue: "Log out") }
        static var logoutConfirmTitle: String {
            String(localized: "settings.logout.confirm.title",
                   defaultValue: "Are you sure you want to leave?")
        }
        static var logoutConfirmMessage: String {
            String(localized: "settings.logout.confirm.message",
                   defaultValue: "You\u{2019}ll lose access to circle members\nand their updates.")
        }
        static var logoutConfirmCancel: String {
            String(localized: "settings.logout.confirm.cancel", defaultValue: "Cancel")
        }
        static var logoutConfirmAction: String {
            String(localized: "settings.logout.confirm.action", defaultValue: "Leave")
        }

        static var userName: String   { String(localized: "settings.user.name",  defaultValue: "Nigar") }
        static var userEmail: String  { String(localized: "settings.user.email", defaultValue: "Fidanguluzada@gmail.com") }
        static var heroLine1: String  { String(localized: "settings.hero.line1", defaultValue: "Boost your journey") }
        static var heroLine2: String  { String(localized: "settings.hero.line2", defaultValue: "for better experiences!") }
        static var upgradeNow: String { String(localized: "settings.upgradeNow", defaultValue: "Upgrade now") }

        static var manageCircle: String         { String(localized: "settings.row.manageCircle",  defaultValue: "Manage Circle") }
        static var notificationSettings: String { String(localized: "settings.row.notifications", defaultValue: "Notification Settings") }
        static var permissions: String          { String(localized: "settings.row.permissions",   defaultValue: "Permissions") }
        static var onRoadSafety: String         { String(localized: "settings.row.onRoadSafety",  defaultValue: "On-road safety") }
        static var shareFeedback: String        { String(localized: "settings.row.shareFeedback", defaultValue: "Share Feedback") }
        static var restorePurchases: String     { String(localized: "settings.row.restore",       defaultValue: "Restore Purchases") }
        static var shareWithFriends: String     { String(localized: "settings.row.share",         defaultValue: "Share with Friends") }
        static var privacyPolicy: String        { String(localized: "settings.row.privacy",       defaultValue: "Privacy Policy & Terms of Use") }
    }

    enum Premium {
        static var title: String    { String(localized: "premium.title",    defaultValue: "Go Premium") }
        static var subtitle: String { String(localized: "premium.subtitle", defaultValue: "Unlock everything") }
        static var cta: String      { String(localized: "premium.cta",      defaultValue: "Start 7-day free trial") }

        static var heroLine1: String  { String(localized: "premium.hero.line1",  defaultValue: "Boost your journey") }
        static var heroLine2: String  { String(localized: "premium.hero.line2",  defaultValue: "for better experiences!") }

        static var planPopular: String      { String(localized: "premium.plan.popular",     defaultValue: "Popular") }
        static var planBestValue: String    { String(localized: "premium.plan.bestValue",   defaultValue: "Best Value") }
        static var planMonthlyPrice: String { String(localized: "premium.plan.monthlyPrice", defaultValue: "USD 2.99") }
        static var planYearlyPrice: String  { String(localized: "premium.plan.yearlyPrice",  defaultValue: "USD 12.99") }
        static var planMonthlyCaption: String { String(localized: "premium.plan.monthlyCaption", defaultValue: "Billed monthly") }
        static var planYearlyCaption: String  { String(localized: "premium.plan.yearlyCaption",  defaultValue: "Billed yearly") }
        static var planSaveBadge: String      { String(localized: "premium.plan.saveBadge",      defaultValue: "Save 20%") }

        static var includedHeader: String     { String(localized: "premium.included.header",     defaultValue: "WHAT`S INCLUDED") }
        static var featureParentalControl: String { String(localized: "premium.feature.parentalControl", defaultValue: "Parental Control") }
        static var featureDrivingSafety: String   { String(localized: "premium.feature.drivingSafety",   defaultValue: "Driving Safety") }
        static var featureHealthGoals: String     { String(localized: "premium.feature.healthGoals",     defaultValue: "Health Goals") }
        static var featurePlaceAlerts: String     { String(localized: "premium.feature.placeAlerts",     defaultValue: "Unlimited Place Alerts") }
        static var featureLocationHistory: String { String(localized: "premium.feature.locationHistory", defaultValue: "30 days Location History") }

        static var trialFootnote: String { String(localized: "premium.trial.footnote", defaultValue: "First 7 days free, then $2.99/month") }

        static var subscribedTitle: String       { String(localized: "premium.subscribed.title",       defaultValue: "Your Premium") }
        static var yourPlanBadge: String         { String(localized: "premium.subscribed.badge",       defaultValue: "Your Plan") }
        static var managePlan: String            { String(localized: "premium.subscribed.manage",      defaultValue: "Manage Plan") }
        static var cancelSubscription: String    { String(localized: "premium.subscribed.cancel",      defaultValue: "Cancle Subscription") }
        static func untilDate(_ date: String) -> String {
            String(localized: "premium.subscribed.until", defaultValue: "Until: \(date)")
        }
        static var featureBonus: String          { String(localized: "premium.feature.bonus",          defaultValue: "Lorem Ipsum Dolor") }
    }

    enum Messages {
        static var title: String          { String(localized: "messages.title",          defaultValue: "Messages") }
        static var circlePill: String     { String(localized: "messages.circle.pill",    defaultValue: "Circle:") }
        static var circleName: String     { String(localized: "messages.circle.name",    defaultValue: "Family") }
    }

    enum Notifications {
        static var title: String        { String(localized: "notifications.title",       defaultValue: "Notifications") }
        static var sectionToday: String { String(localized: "notifications.today",       defaultValue: "Today") }
        static var sectionYesterday: String { String(localized: "notifications.yesterday", defaultValue: "Yesterday") }
        static var sectionOlder: String { String(localized: "notifications.older",       defaultValue: "Older") }
        static var preview: String      { String(localized: "notifications.preview",     defaultValue: "Lorem ipsum dololor lorem dolor mess...") }
        static var circlePill: String   { String(localized: "notifications.circle.pill", defaultValue: "Circle:") }
        static var circleName: String   { String(localized: "notifications.circle.name", defaultValue: "Family") }
        static var filterPlaceAlerts: String { String(localized: "notifications.filter.placeAlerts", defaultValue: "Place Alerts") }
        static var filterSafeDrive: String   { String(localized: "notifications.filter.safeDrive",   defaultValue: "Safe Drive") }
        static var filterPets: String        { String(localized: "notifications.filter.pets",        defaultValue: "Pets") }
        static var filterOffers: String      { String(localized: "notifications.filter.offers",      defaultValue: "Offers") }
        static var filterAll: String         { String(localized: "notifications.filter.all",         defaultValue: "All Notifications") }
    }

    enum Health {
        static var title: String           { String(localized: "health.title",            defaultValue: "Health") }
        static var segLastWeek: String     { String(localized: "health.seg.lastWeek",     defaultValue: "Last Week") }
        static var segYesterday: String    { String(localized: "health.seg.yesterday",    defaultValue: "Yesterday") }
        static var segToday: String        { String(localized: "health.seg.today",        defaultValue: "Today") }
        static var dailySteps: String      { String(localized: "health.dailySteps",       defaultValue: "Daily Steps") }
        static var stepsValue: String      { String(localized: "health.steps.value",      defaultValue: "4,500") }
        static var stepsTotal: String      { String(localized: "health.steps.total",      defaultValue: "of 10,000") }
        static var changeGoal: String      { String(localized: "health.changeGoal",       defaultValue: "Change Goal") }
        static var totalDistance: String   { String(localized: "health.totalDistance",    defaultValue: "Total Distance") }
        static var calories: String        { String(localized: "health.calories",         defaultValue: "Calories") }
        static var activeTime: String      { String(localized: "health.activeTime",       defaultValue: "Active Time") }
        static var distanceValue: String   { String(localized: "health.distance.value",   defaultValue: "24,5 km") }
        static var caloriesValue: String   { String(localized: "health.calories.value",   defaultValue: "358 cal") }
        static var activeTimeValue: String { String(localized: "health.activeTime.value", defaultValue: "1h 24m") }
        static var motivationLine1: String { String(localized: "health.motivation.line1", defaultValue: "Motivation feels") }
        static var motivationLine2: String { String(localized: "health.motivation.line2", defaultValue: "stronger with friends") }
        static var createHabit: String     { String(localized: "health.createHabit",      defaultValue: "Create a Habit") }
        static var challengeBoard: String  { String(localized: "health.challengeBoard",   defaultValue: "Challenge Board") }
        static var inviteFriends: String   { String(localized: "health.inviteFriends",    defaultValue: "Invite friends") }
        static var memberFidan: String     { String(localized: "health.member.fidan",     defaultValue: "Fidan") }
        static var memberYou: String       { String(localized: "health.member.you",       defaultValue: "You") }
        static var todayLabel: String      { String(localized: "health.today",            defaultValue: "Today") }
        static var monthlySummary: String  { String(localized: "health.monthlySummary",   defaultValue: "Monthly Summary") }
        static var movingHistory: String   { String(localized: "health.movingHistory",    defaultValue: "Moving History") }
        static var getAlerts: String       { String(localized: "health.getAlerts",        defaultValue: "Get Alerts") }
        static var address1: String        { String(localized: "health.address.1",        defaultValue: "83 Tabriz St, Narimanov District") }
        static var address2: String        { String(localized: "health.address.2",        defaultValue: "105 Shafayat Mehdiyev St") }
        static var time1: String           { String(localized: "health.time.1",           defaultValue: "09:45") }
        static var time2: String           { String(localized: "health.time.2",           defaultValue: "10:05") }
    }
    enum Kids {
        static var title: String           { String(localized: "kids.title",            defaultValue: "Parental control") }
        static var board: String           { String(localized: "kids.board",            defaultValue: "Fidan’s board") }
        static var deviceName: String      { String(localized: "kids.device.name",      defaultValue: "Fidan’s device") }
        static var deviceOwner: String     { String(localized: "kids.device.owner",     defaultValue: "Rovshan Aliyev, Baku Azerbaijan") }
        static var heroLine1: String       { String(localized: "kids.hero.line1",       defaultValue: "Boost your journey") }
        static var heroLine2: String       { String(localized: "kids.hero.line2",       defaultValue: "for better experiences!") }
        static var heroCTA: String         { String(localized: "kids.hero.cta",         defaultValue: "Upgrade now") }
        static var actionScreenshot: String { String(localized: "kids.action.screenshot", defaultValue: "Screenshot") }
        static var actionListen: String    { String(localized: "kids.action.listen",    defaultValue: "Listen") }
        static var actionScreenLimit: String { String(localized: "kids.action.screenLimit", defaultValue: "Screen limit") }
        static var actionUnlock: String    { String(localized: "kids.action.unlock",    defaultValue: "Unlock") }
        static var liveLocation: String    { String(localized: "kids.liveLocation",     defaultValue: "Live location") }
        static var details: String         { String(localized: "kids.details",          defaultValue: "Details") }
        static var liveAddress: String     { String(localized: "kids.live.address",     defaultValue: "83 Tabriz St, Narimanov District") }
        static var liveSince: String       { String(localized: "kids.live.since",       defaultValue: "Since Jan 12, 21:45") }
        static var screenTime: String      { String(localized: "kids.screenTime",       defaultValue: "Screen Time") }
        static var setLimits: String       { String(localized: "kids.setLimits",        defaultValue: "Set limits") }
        static var screenTimeUsed: String  { String(localized: "kids.screenTime.used",  defaultValue: "4h 18m") }
        static var screenTimeTotal: String { String(localized: "kids.screenTime.total", defaultValue: "of 5h 30 min") }
        static var legendSocial: String    { String(localized: "kids.legend.social",    defaultValue: "Social") }
        static var legendGames: String     { String(localized: "kids.legend.games",     defaultValue: "Games") }
        static var legendOther: String     { String(localized: "kids.legend.other",     defaultValue: "Other") }
        static var statMostUsed: String    { String(localized: "kids.stat.mostUsed",    defaultValue: "Most Used") }
        static var statPickups: String     { String(localized: "kids.stat.pickups",     defaultValue: "Pickups") }
        static var statLastUsed: String    { String(localized: "kids.stat.lastUsed",    defaultValue: "Last Used") }
        static var statPickupsValue: String { String(localized: "kids.stat.pickups.value", defaultValue: "32") }
        static var statLastUsedValue: String { String(localized: "kids.stat.lastUsed.value", defaultValue: "12:45") }
        static var usedApps: String        { String(localized: "kids.usedApps",         defaultValue: "Used Apps") }
        static var appPubg: String         { String(localized: "kids.app.pubg",         defaultValue: "Pubg Mobile") }
        static var appPubgTime: String     { String(localized: "kids.app.pubg.time",    defaultValue: "1h 24min") }
        static var appTiktok: String       { String(localized: "kids.app.tiktok",       defaultValue: "Tiktok") }
        static var appTiktokTime: String   { String(localized: "kids.app.tiktok.time",  defaultValue: "54min") }
        static var appYoutube: String      { String(localized: "kids.app.youtube",      defaultValue: "Youtube") }
        static var appYoutubeTime: String  { String(localized: "kids.app.youtube.time", defaultValue: "2h 04min") }
        static var appInstagram: String    { String(localized: "kids.app.instagram",    defaultValue: "Instagram") }
        static var appInstagramTime: String { String(localized: "kids.app.instagram.time", defaultValue: "2h 12min") }
    }
    enum Driving {
        static var title: String           { String(localized: "driving.title",           defaultValue: "Driving") }
        static var reportTitle: String     { String(localized: "driving.reportTitle",     defaultValue: "Safe Drive Report") }
        static var reportSubtitle: String  { String(localized: "driving.reportSubtitle",  defaultValue: "A quick summary of driving activity for all members in this circle.") }
        static var segmentToday: String    { String(localized: "driving.segment.today",   defaultValue: "Today") }
        static var segmentWeek: String     { String(localized: "driving.segment.week",    defaultValue: "This Week") }
        static var dateRange: String       { String(localized: "driving.dateRange",       defaultValue: "22-29 Jan") }
        static var statDriveCount: String  { String(localized: "driving.stat.driveCount", defaultValue: "Drive Count") }
        static var statDistance: String    { String(localized: "driving.stat.distance",   defaultValue: "Total Distance") }
        static var statMaxSpeed: String    { String(localized: "driving.stat.maxSpeed",   defaultValue: "Max Speed") }
        static var circleSummary: String   { String(localized: "driving.circleSummary",   defaultValue: "Circle Summary") }
        static var peakSpeed: String       { String(localized: "driving.peakSpeed",       defaultValue: "Peak speed") }
        static var suddenSpeedUp: String   { String(localized: "driving.suddenSpeedUp",   defaultValue: "Sudden speed-up") }
        static var sharpStop: String       { String(localized: "driving.sharpStop",       defaultValue: "Sharp stop") }
        static var distractions: String    { String(localized: "driving.distractions",    defaultValue: "Distractions") }
        static var drivesLabel: String     { String(localized: "driving.drives",          defaultValue: "12 Drives") }
        static var kilometresLabel: String { String(localized: "driving.kilometres",      defaultValue: "70 kilometres") }
        static var risks2: String          { String(localized: "driving.risks.two",       defaultValue: "2 Risks") }
        static var risks1: String          { String(localized: "driving.risks.one",       defaultValue: "1 Risk") }
        static var circlePill: String      { String(localized: "driving.circle.pill",     defaultValue: "Circle:") }
        static var circleName: String      { String(localized: "driving.circle.name",     defaultValue: "Family") }
        static var memberNigar: String     { String(localized: "driving.member.nigar",    defaultValue: "Nigar") }
        static var memberFiruza: String    { String(localized: "driving.member.firuza",   defaultValue: "Firuza") }
    }

    // MARK: Units

    enum Units {
        static var kmh: String { String(localized: "units.kmh", defaultValue: "km/h") }
    }
}
