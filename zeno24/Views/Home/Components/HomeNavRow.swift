import SwiftUI

/// 4-tab pill row — SwiftUI port of Flutter iOS `HomeSheetTabRow`.
///
/// `active` reflects the currently visible scroll section (set by the
/// parent's scroll inference); `onTap` fires when the user taps a pill —
/// the parent reacts by scrolling the content to that section's anchor.
/// Selected pill takes its natural width (icon + label), unselected
/// pills share the remaining row equally with a spring transition.
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
