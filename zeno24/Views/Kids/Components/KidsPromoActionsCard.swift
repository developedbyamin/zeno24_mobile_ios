import SwiftUI

struct KidsPromoActionsCard: View {
    var body: some View {
        VStack(spacing: 16) {
            promoBanner
            HStack(spacing: 16) {
                QuickAction(image: AppImages.emojiScreenshot,  bg: Color(hex: 0xEFF7FF), title: AppStrings.Kids.actionScreenshot)
                QuickAction(image: AppImages.emojiListen,      bg: Color(hex: 0xFFF1E5), title: AppStrings.Kids.actionListen)
                QuickAction(image: AppImages.emojiScreenLimit, bg: Color(hex: 0xFFF5CE), title: AppStrings.Kids.actionScreenLimit)
                QuickAction(image: AppImages.emojiUnlock,      bg: Color(hex: 0xF8F9FF), title: AppStrings.Kids.actionUnlock)
            }
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var promoBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0xAC4CC0), Color(hex: 0xEB6659)],
                startPoint: .leading,
                endPoint: .trailing
            )

            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        .frame(width: 95, height: 95)
                        .position(x: proxy.size.width - 30, y: -10)
                    Circle()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        .frame(width: 94, height: 94)
                        .position(x: proxy.size.width - 90, y: proxy.size.height + 8)
                }
                .allowsHitTesting(false)
            }

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(AppStrings.Kids.heroLine1)
                    Text(AppStrings.Kids.heroLine2)
                }
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(.white)
                .padding(.leading, 16)

                Spacer(minLength: 0)

                Button {
                    // TODO: upgrade
                } label: {
                    Text(AppStrings.Kids.heroCTA)
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(AppColors.mainBlack)
                        .padding(.horizontal, 12)
                        .frame(height: 30)
                        .background(Color.white, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.trailing, 12)
            }
        }
        .frame(height: 70)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 16)
    }
}

private struct QuickAction: View {
    let image: String
    let bg: Color
    let title: String

    var body: some View {
        VStack(spacing: 6) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .frame(width: 56, height: 56)
                .background(bg, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            Text(title)
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(AppColors.mainBlack)
        }
        .frame(width: 67)
    }
}
