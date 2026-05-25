import Foundation

struct PanelSyncResponseModel: Decodable {
    let status: String?
    let count: Int?
    let data: [PanelObjectModel]?
}
