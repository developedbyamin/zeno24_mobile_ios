import SwiftUI

struct NotificationRow: View {
    let title: String
    let message: String
    let timestamp: Date
    let isUnread: Bool

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.m) {
            Circle()
                .fill(isUnread ? AppColors.primary : Color.clear)
                .frame(width: 8, height: 8)
                .padding(.top, AppSpacing.s)

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(AppTypography.bodyLgSemiBold)
                Text(message)
                    .font(AppTypography.bodySmRegular)
                    .foregroundStyle(AppColors.labelSecondary)
                Text(timestamp, style: .relative)
                    .font(AppTypography.bodyXsRegular)
                    .foregroundStyle(AppColors.labelTertiary)
            }
        }
    }
}
