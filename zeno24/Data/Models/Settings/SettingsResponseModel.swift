import Foundation

/// Mirrors Flutter's `SettingsResponseModel`. The backend returns a flat
/// payload (no `data` envelope) for `/main/settings`, so this is decoded
/// directly from the response body.
struct SettingsResponseModel: Decodable {
    let status: String?
    let accountData: SettingsAccountModel?
    let circleData: SettingsCircleModel?
    let lang: LangModel?
    let langs: [LangModel]?
    let permissions: [String]?

    // RawValues are camelCase because `APIClient.keyDecodingStrategy =
    // .convertFromSnakeCase` rewrites `account_data` / `circle_data` BEFORE
    // matching, so snake_case raw values silently miss.
    enum CodingKeys: String, CodingKey {
        case status, lang, langs, permissions
        case accountData, circleData
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        status      = try c.decodeIfPresent(String.self, forKey: .status)
        accountData = try c.decodeIfPresent(SettingsAccountModel.self, forKey: .accountData)
        circleData  = try c.decodeIfPresent(SettingsCircleModel.self,  forKey: .circleData)
        lang        = try c.decodeIfPresent(LangModel.self, forKey: .lang)
        langs       = try c.decodeIfPresent([LangModel].self, forKey: .langs)
        // Backend ships `permissions` as a heterogeneous list; preserve only
        // string entries to stay tolerant to type drift on the server.
        if var arr = try? c.nestedUnkeyedContainer(forKey: .permissions) {
            var out: [String] = []
            while !arr.isAtEnd {
                if let s = try? arr.decode(String.self) { out.append(s) }
                else { _ = try? arr.decodeNil() }
            }
            permissions = out
        } else {
            permissions = nil
        }
    }
}
