import Foundation

/// Generic wrapper for incoming API responses — mirrors `app_response_model.dart`.
struct AppResponseModel<T: Decodable>: Decodable {
    let status: String?
    let description: String?
    let token: String?
    let limit: Int?
    let skip: Int?
    let count: Int?
    let pendingCount: Int?
    let data: T?
}
