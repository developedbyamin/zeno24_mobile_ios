import SwiftUI

/// Bottom navigation bar — Figma `4991:14591`.
///
/// Five tabs: Home / Kids / Driving / Health / Premium. Active tab uses
/// the brand color (#9171F4); inactive labels use secondary black.
/// Container is a translucent material with a hairline top border —
/// matches `backdrop-blur(12) + bg-white-76%` from Figma.
struct MainTabBar: View {
    @Binding var selection: AppTab
    /// Called when the user taps the already-selected tab. Use it to
    /// pop the current tab's NavigationStack to root (iOS convention).
    var onReselect: (AppTab) -> Void = { _ in }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                TabBarItem(
                    tab: tab,
                    isActive: selection == tab,
                    action: { handleTap(tab) }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 4)
        .padding(.horizontal, 12)
        .background {
            // Material extends below into the home-indicator zone so the
            // map / underlying content doesn't peek through the gap.
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea(.container, edges: .bottom)
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color(hex: 0xF2F5F9))
                .frame(height: 1)
        }
    }

    private func handleTap(_ tab: AppTab) {
        Haptics.selection()
        if selection == tab {
            onReselect(tab)
        } else {
            selection = tab
        }
    }
}

// MARK: - Item

private struct TabBarItem: View {
    let tab: AppTab
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(tab.iconAsset)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Text(tab.title)
                    .font(AppTypography.body2XsSemiBold)
            }
            .foregroundStyle(isActive ? AppColors.brand : Color(hex: 0x292D32))
            .frame(height: 54)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isActive ? [.isSelected, .isButton] : [.isButton])
    }
}
