import Foundation

/// Output of the native sign-in flow once Firebase has re-signed the
/// underlying Apple/Google credential. This is what gets shipped to the
/// backend's `/auth/sign/step1` — `idToken` is the **Firebase** ID token,
/// not the raw provider one.
struct SocialCredential {
    let provider: String   // "apple" or "google"
    let idToken: String    // Firebase ID token
    let email: String?
    let username: String?
}
