import Foundation

struct InviteCircleResponseModel: Decodable {
    let inviteUrl: String
    let expiresAt: Date?
}
