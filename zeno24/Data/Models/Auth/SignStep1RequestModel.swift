import Foundation

/// Mirrors lib/src/data/models/auth/sign_step1_request_model.dart
/// Encoded as snake_case to match the server contract.
struct SignStep1RequestModel: Encodable {
    var from: String?              // "whatsapp" for phone, omitted for email
    var email: String?
    var phone: String?             // Full digits incl. country code, no '+'
    var countryId: Int?
    var dialCode: String?
    var idToken: String?           // Apple/Google
    var username: String?
    var deviceOtpHash: String?

    enum CodingKeys: String, CodingKey {
        case from, email, phone, username
        case countryId      = "country_id"
        case dialCode       = "dial_code"
        case idToken        = "id_token"
        case deviceOtpHash  = "device_otp_hash"
    }
}
