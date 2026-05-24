import Foundation

/// Last-known activity entry — `panel_history_model.dart`.
struct PanelHistoryModel: Decodable, Hashable {
    let action: String?
    let starttime: String?
    let startunix: Int?
    let duration: String?
}
