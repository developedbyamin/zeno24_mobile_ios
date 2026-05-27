import Foundation

/// `APIClient` is configured with `.convertFromSnakeCase`, so snake_case
/// JSON keys (`is_registered`, etc.) map automatically to camelCase Swift
/// properties — no explicit `CodingKeys` needed (in fact one would *break*
/// the mapping, since the decoder has already lowercased+camelCased the
/// JSON key before it consults the type's coding keys).
struct SignStep1ResponseModel: Decodable {
    let hash: String?
    /// Masked contact line (e.g. `"a****ay@gmail.com"`, `"+994*****12"`) the
    /// backend computes for the OTP screen subtitle.
    let text: String?
    /// `1` if the contact already has an account, `0` if this OTP is gating
    /// a fresh registration. Drives "Welcome back!" vs "Enter the code".
    let isRegistered: Int?
}
