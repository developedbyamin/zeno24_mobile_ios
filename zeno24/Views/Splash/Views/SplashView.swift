import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            AppColors.brand.ignoresSafeArea()
            Text(AppStrings.Brand.name)
                .font(AppTypography.heading2XlBold)
                .foregroundStyle(.white)
        }
    }
}
