import Foundation

/// Top-level shape of the navimax `panelobjects/synclist` endpoint —
/// 1:1 mirror of `panel_sync_response_model.dart`.
struct PanelSyncResponseModel: Decodable {
    let status: String?
    let count: Int?
    let data: [PanelObjectModel]?
}
