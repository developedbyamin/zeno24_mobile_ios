import Foundation

struct CircleMemberModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let avatarUrl: String?
    let phone: String?
    let role: String?
    let joinedAt: Date?
}
