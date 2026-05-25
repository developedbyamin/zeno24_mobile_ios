import Foundation

struct SignStep1RequestModel: Encodable {
    var from: String?
    var email: String?
    var phone: String?
    var countryId: Int?
    var dialCode: String?
    var idToken: String?
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
