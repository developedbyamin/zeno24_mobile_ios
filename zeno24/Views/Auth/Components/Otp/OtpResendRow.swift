import SwiftUI

/// "Haven't received the code? Resend" — Figma 4448:11753.
/// Stateless text row. `isEnabled` controls the Resend tap + opacity.
struct OtpResendRow: View {
    let isEnabled: Bool
    let onResend: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text(AppStrings.Auth.Otp.didntReceive)
                .font(AppTypography.bodySmMedium)
                .foregroundStyle(.white.opacity(0.5))

            Button {
                guard isEnabled else { return }
                Haptics.selection()
                onResend()
            } label: {
                Text(AppStrings.Auth.Otp.resend)
                    .font(AppTypography.bodySmBold)
                    .foregroundStyle(.white.opacity(isEnabled ? 1 : 0.5))
                    .underline()
            }
            .buttonStyle(.plain)
            .disabled(!isEnabled)
        }
    }
}
