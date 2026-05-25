import SwiftUI

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

            VStack(alignment: .leading, spacing: 6) {
                Text(AppStrings.Home.petsHeadline)
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(.white)
                Text(AppStrings.Home.petsSubheadline)
                    .font(AppTypography.bodyXsMedium)
                    .foregroundStyle(.white)
                    .frame(width: 147, alignment: .leading)
            }
            .padding(.leading, 16)
            .offset(y: 11)

            Button {
                Haptics.selection()
                onPair?()
            } label: {
                Text(AppStrings.Home.petsCTA)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .padding(.horizontal, 16)
                    .frame(height: 28)
                    .background(Color(hex: 0xFFE420), in: Capsule())
            }
            .buttonStyle(.plain)
            .offset(x: 16, y: 60)
        }
        .overlay(alignment: .topTrailing) {
            GlowCircle(size: 132, flipped: false)
                .offset(x: 56, y: -91)
        }
        .overlay(alignment: .topTrailing) {
            GlowCircle(size: 120, flipped: true)
                .offset(x: 0, y: 63)
        }
        .overlay(alignment: .topTrailing) {
            Image(AppImages.emojiDog)
                .resizable()
                .scaledToFit()
                .frame(width: 99, height: 99)
                .offset(x: 0, y: 6)
        }
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct GlowCircle: View {
    let size: CGFloat
    let flipped: Bool

    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: flipped
                        ? [Color.white.opacity(0.6), Color.white]
                        : [Color.white, Color.white.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .opacity(0.3)
            .frame(width: size, height: size)
    }
}
