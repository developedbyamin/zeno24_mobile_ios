import Foundation

/// String helpers — mirrors text_helpers.dart
enum TextHelpers {
    static func initials(from name: String?) -> String {
        guard let parts = name?.split(separator: " "), !parts.isEmpty else { return "?" }
        let first = parts.first?.first.map(String.init) ?? ""
        let last  = parts.count > 1 ? (parts.last?.first.map(String.init) ?? "") : ""
        return (first + last).uppercased()
    }

    static func capitalizeFirst(_ s: String) -> String {
        guard let first = s.first else { return s }
        return String(first).uppercased() + s.dropFirst()
    }
}
