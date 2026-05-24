import Foundation

/// Raw object as returned by navimax — mirrors `panel_object_model.dart`.
/// The repository converts these into `MarkerModel`.
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
