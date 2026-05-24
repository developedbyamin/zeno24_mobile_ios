import Foundation

/// Step 2 result: either logs the user in (token present) or hands off a
/// fresh hash for the step-3 sign-up flow.
struct SignStep2ResponseModel: Decodable {
    let token: String?
    let hash: String?
}
