import Foundation

/// Navimax status payload — `panel_status_model.dart`.
struct PanelStatusModel: Decodable, Hashable {
    let id: Int?
    let color: String?
    let type: String?
    let title: String?
}
