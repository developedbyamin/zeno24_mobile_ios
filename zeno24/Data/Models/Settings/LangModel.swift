import Foundation

/// Mirrors Flutter's `LangModel`. Used both for the active language (where
/// the backend includes `flag`) and for the available-languages list (where
/// the backend includes `original`).
struct LangModel: Codable, Hashable, Identifiable {
    let shortCode: String?
    let title: String?
    let flag: String?
    let original: String?

    var id: String { shortCode ?? title ?? UUID().uuidString }

    // RawValue is camelCase because `APIClient.keyDecodingStrategy =
    // .convertFromSnakeCase` rewrites `short_code` → `shortCode` BEFORE
    // matching against CodingKey raw values.
    enum CodingKeys: String, CodingKey {
        case shortCode, title, flag, original
    }
}
