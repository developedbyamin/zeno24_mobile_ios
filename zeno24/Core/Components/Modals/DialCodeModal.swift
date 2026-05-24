import SwiftUI

/// ISO-3166 country model used by the dial-code picker.
struct Country: Identifiable, Hashable {
    let id: String          // ISO 3166-1 alpha-2
    let name: String
    let dialCode: String    // E.164 prefix with leading "+"
    let flag: String        // Unicode flag emoji
    let isPopular: Bool
    /// Backend country id sent in `country_id` — matches the Flutter table.
    /// Nil for entries the backend doesn't recognize.
    let dbId: Int?

    init(id: String,
         name: String,
         dialCode: String,
         flag: String,
         isPopular: Bool = false,
         dbId: Int? = nil) {
        self.id = id
        self.name = name
        self.dialCode = dialCode
        self.flag = flag
        self.isPopular = isPopular
        self.dbId = dbId
    }
}
