import UIKit
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Configure Firebase before any code paths can touch `FirebaseAuth`.
        // Social sign-in wraps the native Apple/Google credential in a
        // Firebase credential and ships the Firebase ID token to the backend
        // (matches the Flutter app's contract — backend verifies via Firebase
        // Admin SDK, not raw provider tokens).
        FirebaseApp.configure()

        // Swizzle `Bundle.main` so user-driven language switches affect
        // every `NSLocalizedString` / `String(localized:)` call site.
        LocalizedBundle.install()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
    }
}
