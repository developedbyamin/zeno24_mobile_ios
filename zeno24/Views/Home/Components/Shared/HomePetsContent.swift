import SwiftUI

/// Pets tab content — Flutter iOS UIKit `HomePlacesPanel` Pets half +
/// `PetsPromoCard`. "Pets" title above a 100pt-tall gradient card with a
/// dog image, two decorative glow circles, the "Pair now" yellow CTA,
/// and a small "NEW" badge in the top-right.
struct HomePetsContent: View {
    var onPair: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(AppStrings.Home.petsTitle)
                .font(AppTypography.bodyMdBold)
                .foregroundStyle(AppColors.mainBlack)

            PetsPromoCard(onPair: onPair)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

private struct PetsPromoCard: View {
    var onPair: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [Color(hex: 0x9687FF), Color(hex: 0xEDA4FF)],
                startPoint: .leading,
                endPoint: .trailing
            )

            // Decorative glow circles (positioned like the UIKit ellipses).
            Circle()
                .strokeBorder(Color.white.opacity(0.32), lineWidth: 1)
                .background(Circle().fill(Color.white.opacity(0.18)))
                .frame(width: 132, height: 132)
                .offset(x: 280, y: -91)
            Circle()
                .strokeBorder(Color.white.opacity(0.28), lineWidth: 1)
                .background(Circle().fill(Color.white.opacity(0.12)))
                .frame(width: 120, height: 120)
                .offset(x: 250, y: 63)

            VStack(alignment: .leading, spacing: 6) {
                Text(AppStrings.Home.petsHeadline)
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(.white)
                Text(AppStrings.Home.petsSubheadline)
                    .font(AppTypography.bodyXsMedium)
                    .foregroundStyle(.white)
                    .frame(width: 147, alignment: .leading)
                Spacer().frame(height: 6)
                Button {
                    Haptics.selection()
                    onPair?()
                } label: {
                    Text(AppStrings.Home.petsCTA)
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(AppColors.mainBlack)
                        .padding(.horizontal, 16)
                        .frame(height: 28)
                        .background(Color(hex: 0xFFE420), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 13)
            .padding(.leading, 16)

            // Dog emoji at the bottom-right.
            Text("🐶")
                .font(.system(size: 64))
                .frame(width: 99, height: 99)
                .offset(x: 250, y: 41)

            NewBadge()
                .frame(width: 36, height: 21)
                .offset(x: 264, y: 0)
        }
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct NewBadge: View {
    var body: some View {
        Text(AppStrings.Home.newBadge)
            .font(AppTypography.body2XsBold)
            .foregroundStyle(AppColors.mainBlack)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xFFE420))
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 6,
                        bottomTrailing: 0,
                        topTrailing: 16
                    )
                )
            )
    }
}
