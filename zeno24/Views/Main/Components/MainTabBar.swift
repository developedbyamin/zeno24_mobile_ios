import SwiftUI

struct MainTabBar: View {
    @Binding var selection: AppTab
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
