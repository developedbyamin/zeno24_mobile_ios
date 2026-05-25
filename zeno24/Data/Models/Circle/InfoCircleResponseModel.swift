import Foundation

struct InfoCircleDataModel: Decodable, Hashable {
    let id: String?
    let title: String?
}

struct InfoCircleResponseModel: Decodable {
    let circleData: InfoCircleDataModel?
    let membersData: [CircleMemberModel]?

    enum CodingKeys: String, CodingKey {
        case circleData = "circle_data"
        case membersData = "members_data"
    }
}
