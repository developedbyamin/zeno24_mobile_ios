import Foundation

/// `/circles/invite` `data` — backend returns the invite code, its QR
/// rendering (base64-encoded image), and a shareable deep link.
struct InviteCircleResponseModel: Decodable {
    let code: String?
    let qr: String?
    let link: String?
}
