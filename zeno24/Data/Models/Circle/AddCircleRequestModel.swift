import Foundation

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
        if let avatarUrl { try c.encode(avatarUrl, forKey: .avatarUrl) }
    }
}
