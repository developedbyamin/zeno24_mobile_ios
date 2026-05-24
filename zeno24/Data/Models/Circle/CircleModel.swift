import Foundation

struct CircleModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let code: String?
    let avatarUrl: String?
    let memberCount: Int
    let isOwner: Bool
    let createdAt: Date?
}
