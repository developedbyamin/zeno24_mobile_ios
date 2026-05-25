import Foundation

struct CircleModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let memberCount: Int
    /// 1 when this circle is the user's active selection (from `/circles/list`).
    let isCurrent: Bool
    let code: String?
    let avatarUrl: String?
    let isOwner: Bool
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case name        = "title"
        case memberCount = "members_count"
        case isCurrent   = "current"
        case code
        case avatarUrl   = "avatar_url"
        case isOwner     = "is_owner"
        case createdAt   = "created_at"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id          = try c.decode(String.self, forKey: .id)
        self.name        = try c.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.memberCount = try c.decodeIfPresent(Int.self,    forKey: .memberCount) ?? 0
        // Backend sends `current` as 0/1; tolerate Bool too.
        if let intVal = try? c.decode(Int.self, forKey: .isCurrent) {
            self.isCurrent = intVal != 0
        } else {
            self.isCurrent = (try? c.decode(Bool.self, forKey: .isCurrent)) ?? false
        }
        self.code        = try c.decodeIfPresent(String.self, forKey: .code)
        self.avatarUrl   = try c.decodeIfPresent(String.self, forKey: .avatarUrl)
        self.isOwner     = try c.decodeIfPresent(Bool.self,   forKey: .isOwner) ?? false
        self.createdAt   = try c.decodeIfPresent(Date.self,   forKey: .createdAt)
    }

    init(id: String,
         name: String,
         memberCount: Int,
         isCurrent: Bool = false,
         code: String? = nil,
         avatarUrl: String? = nil,
         isOwner: Bool = false,
         createdAt: Date? = nil) {
        self.id = id
        self.name = name
        self.memberCount = memberCount
        self.isCurrent = isCurrent
        self.code = code
        self.avatarUrl = avatarUrl
        self.isOwner = isOwner
        self.createdAt = createdAt
    }
}
