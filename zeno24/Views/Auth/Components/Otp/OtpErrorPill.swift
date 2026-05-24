import SwiftUI

/// Red glass pill that surfaces "Incorrect code" without shifting layout.
/// Parent reserves a fixed-height slot so visibility is fully animated
/// via opacity — matches the Flutter `AnimatedOpacity` behavior.
struct OtpErrorPill: View {
    let message: String

    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.white)
            Text(message)
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, AppSpacing.m)
        .padding(.vertical, AppSpacing.xs)
        .background(AppColors.destructive.opacity(0.85), in: Capsule())
    }
}
