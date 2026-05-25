import Foundation

struct ErrorModel: Decodable, Equatable {
    let code: String?
    let message: String?
    let field: String?
}
