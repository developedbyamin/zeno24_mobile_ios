import Foundation

/// Server-side error payload.
struct ErrorModel: Decodable, Equatable {
    let code: String?
    let message: String?
    let field: String?
}
