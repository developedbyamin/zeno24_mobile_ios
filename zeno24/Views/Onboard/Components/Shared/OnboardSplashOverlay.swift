import SwiftUI

/// Brand-colored splash that covers the screen for ~500ms while the video
/// initializes. The wordmark animates a shimmer sweep — matches the
/// Flutter `Shimmer.fromColors(Colors.white, Colors.white70)` look.
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

/// Highlight sweep that slides across a piece of text. Uses a fixed-stop
/// gradient and a translation animation — keeps stop locations stable
/// (SwiftUI logs a runtime warning when locations go out of order).
private struct ShimmerText: View {
    let text: String
    let font: Font
    let baseColor: Color
    let highlightColor: Color

    @State private var offsetX: CGFloat = -1   // -1 = off-screen left, 1 = off-screen right

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
