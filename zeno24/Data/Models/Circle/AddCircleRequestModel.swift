import Foundation

/// `/circles/add` request body — backend expects `title` (snake-cased fields).
struct AddCircleRequestModel: Encodable {
    let title: String
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case title
        case avatarUrl = "avatar_url"
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(title, forKey: .title)
        // `ignoreNull` parity with Flutter — omit when nil.
        if let avatarUrl { try c.encode(avatarUrl, forKey: .avatarUrl) }
    }
}
