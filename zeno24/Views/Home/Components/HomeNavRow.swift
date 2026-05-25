import SwiftUI

struct HomeNavRow: View {
    let active: HomeBottomSection
    let onTap: (HomeBottomSection) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(HomeBottomSection.allCases) { tab in
                HomeNavPill(
                    tab: tab,
                    isSelected: active == tab
                ) {
                    onTap(tab)
                }
            }
        }
        .frame(height: 40)
        .animation(.spring(response: 0.28, dampingFraction: 0.85), value: active)
    }
}

private struct HomeNavPill: View {
    let tab: HomeBottomSection
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(tab.iconAsset)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(isSelected ? .white : AppColors.brand)

                if isSelected {
                    Text(tab.title)
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(.white)
                        .fixedSize()
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 40)
            .frame(maxWidth: isSelected ? nil : .infinity)
            .background(
                Capsule().fill(isSelected ? AppColors.brand : Color.white)
            )
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
