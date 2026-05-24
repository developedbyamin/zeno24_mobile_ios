import SwiftUI

struct MessageChatRow: View {
    let title: String
    let preview: String?
    let avatarUrl: String?

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Circle()
                .fill(AppColors.bgSecondary)
                .frame(width: 48, height: 48)
                .overlay {
                    Text(TextHelpers.initials(from: title))
                        .font(AppTypography.bodyLgSemiBold)
                        .foregroundStyle(AppColors.labelSecondary)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(AppTypography.bodyLgSemiBold)
                if let preview {
                    Text(preview)
                        .font(AppTypography.bodySmRegular)
                        .foregroundStyle(AppColors.labelSecondary)
                        .lineLimit(1)
                }
            }
        }
    }
}
