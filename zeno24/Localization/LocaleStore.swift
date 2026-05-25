import SwiftUI

@MainActor
@Observable
final class LocaleStore {
    private enum Keys { static let language = "app.language_code" }

    var languageCode: String {
        didSet {
            UserDefaults.standard.set(languageCode, forKey: Keys.language)
            LocalizedBundle.setLanguage(languageCode)
        }
    }

    var locale: Locale { Locale(identifier: languageCode) }

    init() {
        let saved = UserDefaults.standard.string(forKey: Keys.language)
        let supported = AppLanguage.allCases.map(\.rawValue)
        let resolved = saved.flatMap { supported.contains($0) ? $0 : nil }
            ?? Locale.current.language.languageCode?.identifier
            ?? AppLanguage.english.rawValue
        self.languageCode = resolved
        LocalizedBundle.setLanguage(resolved)
    }

    func setLanguage(_ language: AppLanguage) {
        languageCode = language.rawValue
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case azerbaijani = "az"
    case english     = "en"
    case russian     = "ru"
    case turkish     = "tr"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .azerbaijani: return "Azərbaycan"
        case .english:     return "English"
        case .russian:     return "Русский"
        case .turkish:     return "Türkçe"
        }
    }
}
