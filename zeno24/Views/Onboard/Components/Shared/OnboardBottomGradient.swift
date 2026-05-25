import SwiftUI

struct OnboardBottomGradient: View {
    var body: some View {
        GeometryReader { proxy in
            LinearGradient(
                stops: [
                    .init(color: AppColors.mainBlack.opacity(0),  location: 0.0),
                    .init(color: AppColors.mainBlack,             location: 0.8771),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: proxy.size.height / 3)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
