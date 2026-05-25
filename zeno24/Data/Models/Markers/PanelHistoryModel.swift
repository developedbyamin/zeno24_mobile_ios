import Foundation

struct PanelHistoryModel: Decodable, Hashable {
    let action: String?
    let starttime: String?
    let startunix: Int?
    let duration: String?
}
