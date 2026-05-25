import SwiftUI

@main
struct zeno24App: App {
    @State private var authStore = AuthStore()
    @State private var settingsStore = SettingsStore()
    @State private var themeStore = ThemeStore()
    @State private var localeStore = LocaleStore()
    @State private var permissionsStore = PermissionsStore()
    @State private var deepLinkStore = DeepLinkStore()
    @State private var premiumStore = PremiumStore()
    @State private var circlesStore = CirclesStore()

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(authStore)
                .environment(settingsStore)
                .environment(themeStore)
                .environment(localeStore)
                .environment(permissionsStore)
                .environment(deepLinkStore)
                .environment(premiumStore)
                .environment(circlesStore)
                .environment(\.appTheme, .default)
                .environment(\.locale, localeStore.locale)
                .preferredColorScheme(.light)
                .id(localeStore.languageCode)
        }
    }
}
