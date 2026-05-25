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
        .background(Color.white)
    }
}

extension AppTopBar where Trailing == Color {
    /// Convenience initializer without a trailing slot — reserves the same
    /// 32×32 footprint with a clear placeholder so the title stays centered.
    init(title: String, onBack: (() -> Void)? = nil) {
        self.init(title: title, onBack: onBack) {
            Color.clear
        }
    }
}
