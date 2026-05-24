import SwiftUI

/// Convenience for localized strings — mirrors localization_extension.dart
extension String {
    /// Lookup in Localizable.strings (default table).
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(_ args: CVarArg...) -> String {
        String(format: NSLocalizedString(self, comment: ""), arguments: args)
    }
}
