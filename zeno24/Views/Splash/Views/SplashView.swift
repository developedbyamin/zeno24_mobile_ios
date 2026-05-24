import SwiftUI

/// Brief brand-colored splash shown while the auth state is resolving.
/// Matches the brand splash overlay that fades out on `OnboardView`.
struct SplashView: View {
    var body: some View {
        ZStack {
            AppColors.brand.ignoresSafeArea()
            VStack(spacing: AppSpacing.l) {
                Text(AppStrings.Brand.name)
                    .font(AppTypography.heading2XlBold)
                    .foregroundStyle(.white)
                ProgressView()
                    .tint(.white)
            }
        }
    }
}
