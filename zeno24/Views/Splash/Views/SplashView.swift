import SwiftUI

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
