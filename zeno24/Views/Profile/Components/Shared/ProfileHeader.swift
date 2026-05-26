import SwiftUI

struct ProfileHeader: View {
    let account: SettingsAccountModel?

    private var displayName: String? {
        if let full = account?.fullname?.trimmingCharacters(in: .whitespacesAndNewlines),
           !full.isEmpty { return full }
        let composed = [account?.firstname, account?.lastname]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        if !composed.isEmpty { return composed }
        return account?.username
    }

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Circle()
                .fill(AppColors.bgSecondary)
                .frame(width: 64, height: 64)
                .overlay {
                    Text(TextHelpers.initials(from: displayName))
                        .font(AppTypography.headingXsSemiBold)
                        .foregroundStyle(AppColors.labelSecondary)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(displayName ?? "—").font(AppTypography.bodyLgSemiBold)
                Text(account?.phone ?? "")
                    .font(AppTypography.bodySmRegular)
                    .foregroundStyle(AppColors.labelSecondary)
            }
        }
    }
}
