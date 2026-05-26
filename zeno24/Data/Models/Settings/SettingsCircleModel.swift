import Foundation

/// Mirrors Flutter's `SettingsCircleModel`. `isPremium` arrives as `0`/`1`
/// from the backend, decoded into a `Bool` for ergonomic use in the UI.
struct SettingsCircleModel: Codable, Hashable {
    let id: String?
    let title: String?
    let ownerId: String?
    let users: [String]?
    let isPremium: Bool?

    // RawValues are camelCase because `APIClient` sets
    // `keyDecodingStrategy = .convertFromSnakeCase`, which rewrites incoming
    // JSON keys (`owner_id`, `is_premium`) into camelCase BEFORE matching.
    enum CodingKeys: String, CodingKey {
        case id, title, users
        case ownerId, isPremium
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id      = try c.decodeIfPresent(String.self, forKey: .id)
        title   = try c.decodeIfPresent(String.self, forKey: .title)
        ownerId = try c.decodeIfPresent(String.self, forKey: .ownerId)
        users   = try c.decodeIfPresent([String].self, forKey: .users)

        if let intValue = try? c.decodeIfPresent(Int.self, forKey: .isPremium) {
            isPremium = intValue == 1
        } else {
            isPremium = try c.decodeIfPresent(Bool.self, forKey: .isPremium)
        }
    }
}
