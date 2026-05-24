import Foundation

/// Server response after step 1 — returns the OTP session hash.
struct SignStep1ResponseModel: Decodable {
    let hash: String?
    let text: String?       // Optional informational message ("code sent to ...")
}
