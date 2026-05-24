import SwiftUI

/// Vertical brand gradient used on every auth screen.
/// Mirrors `AppColors.mainGradient` with the same 3-stop positions.
struct AuthGradientBackground: View {
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: AppColors.gradientTop,    location: 0.0168),
                .init(color: AppColors.gradientMid,    location: 0.6327),
                .init(color: AppColors.gradientBottom, location: 0.9061),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
