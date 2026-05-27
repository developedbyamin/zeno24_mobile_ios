import SwiftUI

struct OtpVerificationHeader: View {
    let channel: AuthContactMode
    let isRegistered: Bool
    /// Backend-supplied masked contact (`a****ay@gmail.com`). Used as the
    /// secondary line for returning email users where we don't have the raw
    /// address handy.
    let maskedContact: String?
    /// Locally pretty-printed contact: full email for the email branch
    /// (`fidan@gmail.com`), formatted phone for the phone branch
    /// (`+994 70 383 12 34`).
    let formattedContact: String
    /// Raw email the user typed — preferred over `maskedContact` on the
    /// first-time-sign-in branch so the address is shown in full.
    let rawEmail: String

    var body: some View {
        VStack(spacing: 0) {
            Text(topLine)
            Text(bottomLine)
        }
        .font(AppTypography.headingXsSemiBold)
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var topLine: String {
        if isRegistered {
            return AppStrings.Auth.Otp.welcomeBack
        }
        switch channel {
        case .phone: return AppStrings.Auth.Otp.codeSentToWhatsapp
        case .email: return AppStrings.Auth.Otp.enterCodeSentTo
        }
    }

    private var bottomLine: String {
        if isRegistered {
            switch channel {
            case .phone: return AppStrings.Auth.Otp.checkYourWhatsapp
            case .email: return AppStrings.Auth.Otp.checkYourEmail
            }
        }
        switch channel {
        case .phone:
            // Prefer the locally-formatted "+994 70 ..." over the backend's
            // unmasked digits.
            return formattedContact
        case .email:
            // First-time email sign-in shows the full address, not the
            // masked one — we already know what the user typed.
            let trimmed = rawEmail.trimmingCharacters(in: .whitespaces)
            return trimmed.isEmpty ? (maskedContact ?? "") : trimmed
        }
    }
}
