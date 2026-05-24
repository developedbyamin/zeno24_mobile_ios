import SwiftUI

/// Premium paywall sheet — mirrors premium views
struct PremiumView: View {
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Image(systemName: "crown.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppColors.warning)
            Text(AppStrings.Premium.title).font(AppTypography.headingMdBold)
            Text(AppStrings.Premium.subtitle)
                .font(AppTypography.bodyLgRegular)
                .foregroundStyle(AppColors.labelSecondary)
                .multilineTextAlignment(.center)

            // TODO: plan picker, FeatureList
            Spacer()

            CustomButton(title: AppStrings.Premium.cta) {
                // TODO: trigger purchase
            }
        }
        .padding(AppSpacing.l)
    }
}
