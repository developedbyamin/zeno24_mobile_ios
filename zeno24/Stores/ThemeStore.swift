import SwiftUI

/// Theme mode state — mirrors theme_provider.dart
@MainActor
@Observable
final class ThemeStore {
    private enum Keys { static let mode = "app.theme_mode" }

    enum Mode: String, CaseIterable, Identifiable {
        case system, light, dark
        var id: String { rawValue }
    }

    var mode: Mode {
        didSet { UserDefaults.standard.set(mode.rawValue, forKey: Keys.mode) }
    }

    var colorScheme: ColorScheme? {
        switch mode {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: Keys.mode) ?? Mode.system.rawValue
        self.mode = Mode(rawValue: raw) ?? .system
    }
}
