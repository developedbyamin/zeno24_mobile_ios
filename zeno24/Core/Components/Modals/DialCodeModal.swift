import SwiftUI

struct Country: Identifiable, Hashable {
    let id: String
    let name: String
    let dialCode: String
    let flag: String
    let isPopular: Bool
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
