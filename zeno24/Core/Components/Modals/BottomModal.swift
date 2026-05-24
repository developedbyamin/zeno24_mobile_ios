import SwiftUI

/// iOS-style bottom sheet container — mirrors ios_bottom_modal.dart
struct BottomModal<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: AppSpacing.l) {
            Capsule()
                .fill(AppColors.separator)
                .frame(width: 36, height: 4)
                .padding(.top, AppSpacing.s)

            if let title {
                Text(title)
                    .font(AppTypography.headingXsSemiBold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppSpacing.l)
            }

            content()
                .padding(.horizontal, AppSpacing.l)
        }
        .padding(.bottom, AppSpacing.xxl)
        .background(AppColors.bgPrimary)
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: AppSpacing.radiusHero,
                                   topTrailing: AppSpacing.radiusHero)
            )
        )
    }
}
