import Foundation

struct SettingsAccountModel: Codable, Hashable {
    let id: String
    let name: String
    let phone: String?
    let email: String?
    let avatarUrl: String?
    let isPremium: Bool
}
