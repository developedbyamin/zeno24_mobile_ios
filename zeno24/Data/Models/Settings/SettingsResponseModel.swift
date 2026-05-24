import Foundation

struct SettingsResponseModel: Decodable {
    let account: SettingsAccountModel
    let circle: SettingsCircleModel?
    let language: LangModel
}
