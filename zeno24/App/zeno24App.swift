import SwiftUI
import GoogleSignIn

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
    @State private var markersStore = MarkersStore()
    @State private var bootstrapStore = BootstrapStore()

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
                .environment(markersStore)
                .environment(bootstrapStore)
                .environment(\.appTheme, .default)
                .environment(\.locale, localeStore.locale)
                .preferredColorScheme(.light)
                .id(localeStore.languageCode)
                .onAppear {
                    bootstrapStore.attach(
                        settings: settingsStore,
                        circles: circlesStore,
                        markers: markersStore,
                        premium: premiumStore
                    )
                    // Lets `AuthStore` run bootstrap inline at the end of a
                    // sign-in so the auth screen's spinner stays up until
                    // MainView is actually ready — no SplashView flash
                    // between auth completion and MainView render.
                    authStore.bootstrap = bootstrapStore
                }
                .onOpenURL { url in
                    // Google's OAuth callback comes back via the reversed-
                    // client URL scheme; let the SDK consume it first. If
                    // it isn't a Google URL, fall through to deep-link
                    // routing (invite codes, universal-link fallbacks).
                    if GIDSignIn.sharedInstance.handle(url) { return }
                    deepLinkStore.handle(url)
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    deepLinkStore.handle(userActivity: activity)
                }
        }
    }
}
