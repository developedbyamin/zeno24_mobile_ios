import Foundation

/// Generic wrapper for outgoing API payloads — mirrors `app_request_model.dart`
/// (dart_mappable `ignoreNull: true`). Nil fields are omitted by Swift's
/// synthesized `encodeIfPresent`, so the on-wire shape matches Flutter:
/// `{"data": { ... }}` when only `data` is set.
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
