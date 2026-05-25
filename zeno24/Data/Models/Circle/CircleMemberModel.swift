import Foundation

struct CircleMemberModel: Codable, Identifiable, Hashable {
    let id: String
    let title: String?
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case avatarUrl = "avatar_url"
    }
}
