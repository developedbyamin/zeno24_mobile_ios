import Foundation

struct AppRequestModel<T: Encodable>: Encodable {
    let source: String?
    let lang: String?
    let appId: Int?
    let token: String?
    let data: T?

    init(
        source: String? = nil,
        lang: String? = nil,
        appId: Int? = nil,
        token: String? = nil,
        data: T? = nil
    ) {
        self.source = source
        self.lang = lang
        self.appId = appId
        self.token = token
        self.data = data
    }
}
