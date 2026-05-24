import Foundation

/// Lets the app pick its own UI language at runtime instead of inheriting
/// it from system settings. Implemented as an `object_setClass` swizzle
/// on `Bundle.main` — every `NSLocalizedString` / `String(localized:)`
/// call routes through `localizedString(forKey:value:table:)` here, which
/// pulls the translation from the bundle backed by `LocaleStore.languageCode`.
///
/// Install once at launch:
///
///     LocalizedBundle.install()
///
/// then mutate `LocaleStore.languageCode` to switch languages. Pair with
/// `.id(localeStore.languageCode)` on the root view so SwiftUI re-renders
/// when the language changes.
final class LocalizedBundle: Bundle, @unchecked Sendable {

    // MARK: - Active bundle

    /// Bundle for the language currently selected by the user. When the
    /// `.lproj` folder for that language isn't bundled we fall back to
    /// the default behaviour by returning `nil` (the original `Bundle.main`
    /// implementation runs).
    static var currentBundle: Bundle?

    /// Refresh `currentBundle` from a language code (e.g. "az", "en").
    @MainActor
    static func setLanguage(_ code: String) {
        if let path = Bundle.main.path(forResource: code, ofType: "lproj") {
            currentBundle = Bundle(path: path)
        } else {
            // No translation file — let the system fall back to base/dev language.
            currentBundle = nil
        }
    }

    // MARK: - Install

    /// Swap `Bundle.main`'s class once. Safe to call multiple times.
    private static let installOnce: Void = {
        object_setClass(Bundle.main, LocalizedBundle.self)
    }()

    static func install() { _ = installOnce }

    // MARK: - Override

    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        guard let bundle = LocalizedBundle.currentBundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
