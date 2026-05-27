import SwiftUI

/// Custom top bar used across Messages / Notifications / Settings and on the
/// Kids / Driving / Health tab roots — matches Figma 4991:18818 (pushed) and
/// 6937:6054 (tab). 32×32 circular back button (gray `#F2F5F9` fill, 16pt
/// arrow-left icon) when `onBack` is provided, centered title (Body Sm
/// SemiBold), optional trailing slot symmetric to the back button. Tab roots
/// pass `onBack: nil` — the bar then reserves the 32×32 footprint with a
/// clear placeholder so the title stays centered. The whole bar lives on a
/// white background with a 16pt bottom corner radius and replaces the iOS
/// native navigation bar (which the screens hide via `.toolbar(.hidden)`).
struct AppTopBar<Trailing: View>: View {
    let title: String
    let onBack: (() -> Void)?
    var bottomCornerRadius: CGFloat = 0
    var statusBarColor: Color = .white
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        ZStack {
            Text(title)
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            HStack {
                if let onBack {
                    Button(action: onBack) {
                        Image(AppVectors.backArrow)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(AppColors.mainBlack)
                            .frame(width: 32, height: 32)
                            .background(Color(hex: 0xF2F5F9), in: Circle())
                    }
                    .buttonStyle(.plain)
                } else {
                    Color.clear.frame(width: 32, height: 32)
                }

                Spacer()

                trailing()
                    .frame(width: 32, height: 32)
            }
        }
        .frame(height: 32)
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(
            Color.white,
            in: UnevenRoundedRectangle(
                bottomLeadingRadius: bottomCornerRadius,
                bottomTrailingRadius: bottomCornerRadius,
                style: .continuous
            )
        )
        .overlay(alignment: .top) {
            statusBarColor
                .frame(height: 0)
                .background(statusBarColor.ignoresSafeArea(edges: .top))
        }
    }
}

extension AppTopBar where Trailing == Color {
    /// Convenience initializer without a trailing slot — reserves the same
    /// 32×32 footprint with a clear placeholder so the title stays centered.
    init(title: String, onBack: (() -> Void)? = nil, bottomCornerRadius: CGFloat = 0, statusBarColor: Color = .white) {
        self.init(title: title, onBack: onBack, bottomCornerRadius: bottomCornerRadius, statusBarColor: statusBarColor) {
            Color.clear
        }
    }
}

extension View {
    /// Attaches an `AppTopBar` as a top safe-area inset and hides the native
    /// navigation bar. Replaces the boilerplate of `safeAreaInset` +
    /// `navigationBarBackButtonHidden` + `toolbar(.hidden)` on each screen.
    func appTopBar(
        title: String,
        onBack: (() -> Void)? = nil,
        bottomCornerRadius: CGFloat = 0,
        statusBarColor: Color = .white,
        spacing: CGFloat = 0
    ) -> some View {
        safeAreaInset(edge: .top, spacing: spacing) {
            AppTopBar(
                title: title,
                onBack: onBack,
                bottomCornerRadius: bottomCornerRadius,
                statusBarColor: statusBarColor
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableInteractivePopGesture()
    }

    /// Chat-screen variant (Figma 5865:7143). Two-line centered header
    /// (`title` + smaller `subtitle`) with a 40pt circular avatar in the
    /// trailing slot. Back button keeps the 32pt circle look so it lines up
    /// visually with the rest of the app's top bars.
    func chatTopBar(
        title: String,
        subtitle: String,
        avatarAsset: String? = nil,
        avatarInitialColor: Color = Color(hex: 0xFF5F03),
        bottomCornerRadius: CGFloat = 16,
        spacing: CGFloat = 0,
        onBack: @escaping () -> Void,
        onAvatarTap: (() -> Void)? = nil
    ) -> some View {
        safeAreaInset(edge: .top, spacing: spacing) {
            ChatTopBar(
                title: title,
                subtitle: subtitle,
                avatarAsset: avatarAsset,
                avatarInitialColor: avatarInitialColor,
                bottomCornerRadius: bottomCornerRadius,
                onBack: onBack,
                onAvatarTap: onAvatarTap
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableInteractivePopGesture()
    }
}

/// Chat-thread header (Figma 5865:7145). Lives in this file so the layout
/// metrics (32pt back button circle, 16pt bottom corner radius, white bg)
/// stay consistent with `AppTopBar`.
struct ChatTopBar: View {
    let title: String
    let subtitle: String
    let avatarAsset: String?
    let avatarInitialColor: Color
    var bottomCornerRadius: CGFloat = 16
    let onBack: () -> Void
    var onAvatarTap: (() -> Void)? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Text(title)
                    .font(AppTypography.bodyMdSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text(subtitle)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
            .lineLimit(1)

            HStack {
                Button(action: onBack) {
                    Image(AppVectors.backArrow)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(AppColors.mainBlack)
                        .frame(width: 32, height: 32)
                        .background(Color(hex: 0xF2F5F9), in: Circle())
                }
                .buttonStyle(.plain)

                Spacer()

                // No tap handler → render plain, otherwise SwiftUI dims a
                // disabled Button's label to ~40% opacity and the avatar
                // reads as washed out.
                if let onAvatarTap {
                    Button(action: onAvatarTap) {
                        avatar
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                } else {
                    avatar
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(
            Color.white,
            in: UnevenRoundedRectangle(
                bottomLeadingRadius: bottomCornerRadius,
                bottomTrailingRadius: bottomCornerRadius,
                style: .continuous
            )
        )
        .overlay(alignment: .top) {
            Color.white
                .frame(height: 0)
                .background(Color.white.ignoresSafeArea(edges: .top))
        }
    }

    @ViewBuilder
    private var avatar: some View {
        if let avatarAsset {
            Image(avatarAsset)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Circle().fill(avatarInitialColor)
                Text(String(title.prefix(1)).uppercased())
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(.white)
            }
        }
    }
}
