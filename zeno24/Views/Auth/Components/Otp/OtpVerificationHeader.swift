import SwiftUI

struct OtpVerificationHeader: View {
    let channel: AuthContactMode

    var body: some View {
        VStack(spacing: 0) {
            Text(AppStrings.Auth.Otp.welcomeBack)
            Text(channelLine)
        }
        .font(AppTypography.headingXsSemiBold)
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var channelLine: String {
        switch channel {
        case .phone: return AppStrings.Auth.Otp.checkYourWhatsapp
        case .email: return AppStrings.Auth.Otp.checkYourEmail
        }
    }
}
