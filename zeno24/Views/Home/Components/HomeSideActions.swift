import SwiftUI

/// Two glass-circle action buttons on the right edge of the map.
///
/// Positioning: always 16 pt above the bottom panel's top edge, 16 pt from
/// the trailing edge — tracks the panel in real time during drag.
/// Hides (opacity 0, non-interactive) once the panel passes the half-expanded
/// threshold (normalized > 0.5), exactly as UIKit does with zPosition = 0.
struct HomeSideActions: View {
    /// Live Y of the panel's top edge in the shared ZStack coordinate space.
    let sheetTopY: CGFloat
    /// 0 = collapsed, 0.5 = half-expanded, 1 = fully expanded.
    let normalizedOffset: CGFloat
    var onMapType: (() -> Void)? = nil
    var onZoomSelf: (() -> Void)? = nil

    private let buttonStackHeight: CGFloat = 88  // 40 + 8 + 40
    private let gap: CGFloat = 16
    private let trailingPadding: CGFloat = 16

    private var isHidden: Bool { normalizedOffset > 0.5 }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 8) {
                GlassCircleButton(asset: AppVectors.frame,  action: onMapType)
                GlassCircleButton(asset: AppVectors.marker, action: onZoomSelf)
            }
            .frame(width: 40)
            .position(
                x: proxy.size.width - trailingPadding - 20,
                y: sheetTopY - gap - buttonStackHeight / 2
            )
            .opacity(isHidden ? 0 : 1)
            .allowsHitTesting(!isHidden)
            .animation(.spring(response: 0.3, dampingFraction: 0.85), value: sheetTopY)
            .animation(.easeInOut(duration: 0.2), value: isHidden)
        }
    }
}

// MARK: - Glass circle button

/// Matches UIKit `HomeGlassCircleButton`:
/// ultraThinMaterialLight blur + white tint (56% opacity) + white 2pt border + shadow.
/// Icon tinted brand purple (#9171F4), 20×20 pt centered in a 40×40 pt hit target.
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
