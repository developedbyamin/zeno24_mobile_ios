import SwiftUI

/// App settings — mirrors settings_view.dart
struct SettingsView: View {
    @Environment(LocaleStore.self) private var locale
    @Environment(ThemeStore.self) private var theme
    @Environment(AuthStore.self) private var auth

    var body: some View {
        Form {
            Section(AppStrings.Settings.language) {
                Picker(AppStrings.Settings.language, selection: Binding(
                    get: { AppLanguage(rawValue: locale.languageCode) ?? .english },
                    set: { locale.setLanguage($0) })
                ) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
            }

            Section(AppStrings.Settings.appearance) {
                Picker(AppStrings.Settings.theme, selection: Bindable(theme).mode) {
                    ForEach(ThemeStore.Mode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }
            }

            Section {
                Button(AppStrings.Settings.logout, role: .destructive) {
                    Task { await auth.logout() }
                }
            }
        }
        .navigationTitle(AppStrings.Tab.settings)
    }
}
