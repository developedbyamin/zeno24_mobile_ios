import SwiftUI

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
