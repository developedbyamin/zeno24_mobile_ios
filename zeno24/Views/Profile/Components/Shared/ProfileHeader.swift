import SwiftUI

struct ProfileHeader: View {
    let account: SettingsAccountModel?

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Circle()
                .fill(AppColors.bgSecondary)
                .frame(width: 64, height: 64)
                .overlay {
                    Text(TextHelpers.initials(from: account?.name))
                        .font(AppTypography.headingXsSemiBold)
                        .foregroundStyle(AppColors.labelSecondary)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(account?.name ?? "—").font(AppTypography.bodyLgSemiBold)
                Text(account?.phone ?? "")
                    .font(AppTypography.bodySmRegular)
                    .foregroundStyle(AppColors.labelSecondary)
            }
        }
    }
}
