import SwiftUI

struct OnboardSplashOverlay: View {
    let isVisible: Bool

    var body: some View {
        ZStack {
            AppColors.brand
            ShimmerText(text: AppStrings.Brand.name,
                        font: AppTypography.heading2XlBold,
                        baseColor: .white,
                        highlightColor: .white.opacity(0.5))
        }
        .ignoresSafeArea()
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.5), value: isVisible)
        .allowsHitTesting(isVisible)
    }
}

private struct ShimmerText: View {
    let text: String
    let font: Font
    let baseColor: Color
    let highlightColor: Color

    @State private var offsetX: CGFloat = -1

    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(baseColor)
            .overlay {
                GeometryReader { proxy in
                    let width = proxy.size.width
                    LinearGradient(
                        stops: [
                            .init(color: .clear,         location: 0.0),
                            .init(color: highlightColor, location: 0.5),
                            .init(color: .clear,         location: 1.0),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: width * 0.6)
                    .offset(x: offsetX * width)
                    .mask(
                        Text(text)
                            .font(font)
                            .foregroundStyle(.black)
                    )
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    offsetX = 1
                }
            }
    }
}
