import Foundation

struct InfoCircleResponseModel: Decodable {
    let circle: CircleModel
    let members: [CircleMemberModel]
}
