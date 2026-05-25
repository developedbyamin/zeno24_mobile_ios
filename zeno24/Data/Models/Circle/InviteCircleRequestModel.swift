import Foundation

struct InviteCircleRequestModel: Encodable {
    let circleId: String
    let role: String?

    enum CodingKeys: String, CodingKey {
        case circleId = "circle_id"
        case role
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(circleId, forKey: .circleId)
        if let role { try c.encode(role, forKey: .role) }
    }
}
