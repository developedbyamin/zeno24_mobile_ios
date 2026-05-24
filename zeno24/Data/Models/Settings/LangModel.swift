import Foundation

struct LangModel: Codable, Hashable {
    let code: String   // "az", "en", "ru", "tr"
    let name: String?
}
