import SwiftUI

struct HomeTopBar: View {
    let circleTitle: String
    var opacity: CGFloat = 1.0
    var scale: CGFloat = 1.0
    var onSettings: (() -> Void)? = nil
    var onCircle: (() -> Void)? = nil
    var onNotification: (() -> Void)? = nil
    var onChat: (() -> Void)? = nil

    @Environment(\.circlePillNamespace) private var pillNS
    @Environment(\.circlePickerOpen) private var pickerOpen

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            HomeGlassCircleButton(asset: AppVectors.setting, action: onSettings)

            Group {
                if !pickerOpen {
                    HomeCirclePill(title: circleTitle, action: onCircle)
                        .modifier(CirclePillHeroModifier(namespace: pillNS))
                } else {
                    Color.clear
                }
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 4) {
                HomeGlassCircleButton(
                    asset: AppVectors.notification2,
                    badgeCount: 2,
                    action: onNotification
                )
                HomeGlassCircleButton(
                    asset: AppVectors.chat,
                    badgeCount: 2,
                    action: onChat
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 6)
        .scaleEffect(scale, anchor: .top)
        .opacity(opacity)
        .animation(.smooth(duration: 0.3), value: opacity)
        .animation(.smooth(duration: 0.3), value: scale)
    }
}

// MARK: - Glass circle button

private struct HomeGlassCircleButton: View {
    let asset: String
    var badgeCount: Int? = nil
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
                .background { HomeGlassBackground(shape: Circle()) }
                .overlay(alignment: .topTrailing) {
                    if let count = badgeCount {
                        HomeBadgeView(count: count)
                            .frame(width: 20, height: 20)
                            .offset(x: 4, y: -4)
                    }
                }
        }
        .buttonStyle(GlassPressStyle())
    }
}

// MARK: - Circle pill

private struct HomeCirclePill: View {
    let title: String
    var action: (() -> Void)?

    var body: some View {
        Button { action?() } label: {
            ZStack {
                HomeGlassBackground(shape: Capsule())

                HStack(spacing: 8) {
                    Image(AppVectors.circleGridInterface)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(AppColors.brand)

                    Text(title)
                        .font(.custom("PlusJakartaSans-Bold", size: 13))
                        .foregroundStyle(AppColors.secondaryBlack)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.horizontal, 14)

                Image(AppVectors.arrowDown)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(AppColors.mainBlack)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 12)
                    .allowsHitTesting(false)
            }
            .frame(height: 40)
        }
        .buttonStyle(GlassPressStyle())
    }
}

// MARK: - Glass background

/// Reusable glass surface — ultra-thin material blur + 56% white tint +
/// 2 pt white border + subtle drop shadow. Matches UIKit `HomeGlassView`.
private struct HomeGlassBackground<S: InsettableShape>: View {
    let shape: S

    var body: some View {
        ZStack {
            shape.fill(.ultraThinMaterial)
            shape.fill(Color.white.opacity(0.56))
            shape.strokeBorder(Color.white, lineWidth: 2)
        }
        .shadow(
            color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1),
            radius: 2, x: 0, y: 1
        )
    }
}

// MARK: - Press feedback

/// Mirrors UIKit's `isHighlighted` fade — 0.7 alpha on press, 0.12s ease.
private struct GlassPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Badge

/// 20×20 circle with a radial red→pink gradient, 1 pt white border, and
/// a centered count. Matches UIKit `HomeBadgeView`.
private struct HomeBadgeView: View {
    let count: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(red: 0xE1/255, green: 0x0F/255, blue: 0x0F/255), location: 0),
                            .init(color: Color(red: 0xF0/255, green: 0x53/255, blue: 0x53/255), location: 0.7),
                            .init(color: Color(red: 0xFF/255, green: 0x97/255, blue: 0x97/255), location: 1),
                        ]),
                        center: UnitPoint(x: 0.5, y: 0.55),
                        startRadius: 0,
                        endRadius: 14
                    )
                )
            Circle().strokeBorder(Color.white, lineWidth: 1)
            Text("\(count)")
                .font(AppTypography.body2XsBold)
                .foregroundStyle(.white)
        }
    }
}
