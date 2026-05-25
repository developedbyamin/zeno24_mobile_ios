import SwiftUI

struct OtpModeToggle: View {
    @Bindable var store: AuthStore

    var body: some View {
        Button(action: switchToEmail) {
            HStack(spacing: 8) {
                Text(AppStrings.Auth.Toggle.dontHaveWhatsapp)
                    .font(AppTypography.bodySmSemiBold)
                    .foregroundStyle(.white)

                Text(AppStrings.Auth.Toggle.useEmail)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white, in: Capsule())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.12), in: Capsule())
            .overlay {
                Capsule().strokeBorder(Color.white.opacity(0.16), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private func switchToEmail() {
        Haptics.selection()
        store.contactMode = .email
        store.phoneNumber = ""
        store.goBack()
    }
}
