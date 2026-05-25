import Foundation

struct PanelObjectModel: Decodable {
    let id: String?
    let title: String?
    let username: String?
    let battery: Int?
    let isCharging: Int?
    let connectedAt: Int?
    let speedVal: Double?
    let lasttime: String?
    let avatar: PanelAvatarModel?
    let coords: PanelCoordsModel?
    let status: PanelStatusModel?
    let lastHistory: PanelHistoryModel?
}
