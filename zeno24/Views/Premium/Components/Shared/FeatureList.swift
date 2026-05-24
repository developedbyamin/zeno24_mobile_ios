import SwiftUI

struct FeatureList: View {
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            ForEach(items, id: \.self) { item in
                HStack(spacing: AppSpacing.s) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppColors.success)
                    Text(item).font(AppTypography.bodyLgRegular)
                }
            }
        }
    }
}
