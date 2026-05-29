import SwiftUI

struct HomeSideActions: View {
    let metrics: HomeSheetMetrics
    var onMapType: (() -> Void)? = nil
    var onZoomSelf: (() -> Void)? = nil

    private let buttonStackHeight: CGFloat = 88
    private let gap: CGFloat = 16
    private let trailingPadding: CGFloat = 16

    private var isHidden: Bool { metrics.normalized > 0.5 }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 8) {
                GlassCircleButton(asset: AppVectors.frame,  action: onMapType)
                GlassCircleButton(asset: AppVectors.marker, action: onZoomSelf)
            }
            .frame(width: 40)
            .position(
                x: proxy.size.width - trailingPadding - 20,
                y: metrics.topY - gap - buttonStackHeight / 2
            )
            .opacity(isHidden ? 0 : 1)
            .allowsHitTesting(!isHidden)
            .animation(.easeInOut(duration: 0.2), value: isHidden)
        }
    }
}

// MARK: - Glass circle button

private struct GlassCircleButton: View {
    let asset: String
    var action: (() -> Void)?

    var body: some View {
        Button { action?() } label: {
            Image(asset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(AppColors.brand)
                .frame(width: 40, height: 40)
                .background {
                    ZStack {
                        Circle().fill(.ultraThinMaterial)
                        Circle().fill(Color.white.opacity(0.56))
                        Circle().strokeBorder(Color.white, lineWidth: 2)
                    }
                }
                .shadow(
                    color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1),
                    radius: 2, x: 0, y: 1
                )
        }
        .buttonStyle(.plain)
    }
}
