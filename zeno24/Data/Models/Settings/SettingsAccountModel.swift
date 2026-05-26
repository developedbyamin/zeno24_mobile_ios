import Foundation

/// Mirrors Flutter's `SettingsAccountModel`. The backend ships unset string
/// fields (e.g. `phone`, `email`) as the JSON boolean `false`, so every
/// `String?` field is funneled through `SafeString.decode` to match Flutter's
/// `SafeDecodingHook` behaviour.
struct SettingsAccountModel: Codable, Hashable {
    let id: String?
    let username: String?
    let firstname: String?
    let lastname: String?
    let fullname: String?
    let phone: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case id, username, firstname, lastname, fullname, phone, email
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id        = try SafeString.decode(c, forKey: .id)
        username  = try SafeString.decode(c, forKey: .username)
        firstname = try SafeString.decode(c, forKey: .firstname)
        lastname  = try SafeString.decode(c, forKey: .lastname)
        fullname  = try SafeString.decode(c, forKey: .fullname)
        phone     = try SafeString.decode(c, forKey: .phone)
        email     = try SafeString.decode(c, forKey: .email)
    }
}
