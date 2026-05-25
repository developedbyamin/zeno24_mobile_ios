import Foundation

/// Backend returns the new circle's MongoDB id wrapped in
/// extended-JSON (`{"$oid": "..."}`); unwrap it to a plain string.
struct AddCircleResponseModel: Decodable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id
    }

    private enum OidKey: String, CodingKey {
        case oid = "$oid"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let nested = try? c.nestedContainer(keyedBy: OidKey.self, forKey: .id) {
            self.id = try nested.decode(String.self, forKey: .oid)
        } else {
            self.id = try c.decode(String.self, forKey: .id)
        }
    }
}
