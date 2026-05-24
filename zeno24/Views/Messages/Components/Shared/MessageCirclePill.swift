import SwiftUI

struct MessageCirclePill: View {
    let name: String
    let isSelected: Bool

    var body: some View {
        Text(name)
            .font(AppTypography.bodySmRegular)
            .padding(.horizontal, AppSpacing.m)
            .padding(.vertical, AppSpacing.xs)
            .background(isSelected ? AppColors.primary : AppColors.bgSecondary)
            .foregroundStyle(isSelected ? .white : AppColors.labelPrimary)
            .clipShape(Capsule())
    }
}
