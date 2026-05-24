import Foundation

/// Navimax avatar sizes — `panel_avatar_model.dart`.
struct PanelAvatarModel: Decodable, Hashable {
    let tiny: String?
    let small: String?
    let medium: String?
    let large: String?
    let nophoto: Bool?
}
