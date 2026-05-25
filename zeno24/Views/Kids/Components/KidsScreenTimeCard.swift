import SwiftUI

struct KidsScreenTimeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(AppStrings.Kids.screenTime)
                    .font(AppTypography.bodyMdSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
                Spacer()
                Button {
                } label: {
                    Text(AppStrings.Kids.setLimits)
                        .font(AppTypography.bodySmSemiBold)
                        .foregroundStyle(AppColors.brand)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)

            HStack(alignment: .bottom, spacing: 6) {
                Text(AppStrings.Kids.screenTimeUsed)
                    .font(AppTypography.headingMdBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text(AppStrings.Kids.screenTimeTotal)
                    .font(AppTypography.bodyXsMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
                    .padding(.bottom, 4)
                Spacer()
            }
            .padding(.horizontal, 16)

            VStack(spacing: 12) {
                HStack(spacing: 1) {
                    Color(hex: 0xFF9411)
                    Color(hex: 0x9171F4)
                    Color(hex: 0x2FC3D9)
                }
                .frame(height: 10)
                .clipShape(Capsule())
                .background(Color(hex: 0xF8F7FF), in: Capsule())

                HStack(spacing: 0) {
                    legendDot(color: Color(hex: 0xFF9411), label: AppStrings.Kids.legendSocial)
                    Color(hex: 0xF2F5F9).frame(width: 1, height: 16)
                    legendDot(color: Color(hex: 0x9171F4), label: AppStrings.Kids.legendGames)
                    Color(hex: 0xF2F5F9).frame(width: 1, height: 16)
                    legendDot(color: Color(hex: 0x2FC3D9), label: AppStrings.Kids.legendOther)
                }

                statsRow
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 8) {
            Circle().fill(color).frame(width: 12, height: 12)
            Text(label)
                .font(AppTypography.bodyXsBold)
                .foregroundStyle(AppColors.mainBlack)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            VStack(spacing: 8) {
                HStack(spacing: -8) {
                    appBadge(bg: .red,                content: Image(AppVectors.appYoutube).resizable().scaledToFit().padding(4))
                    appBadge(bg: .black,              content: Image(AppVectors.appTiktok).resizable().scaledToFit().padding(4))
                    appBadge(bg: Color(hex: 0x5865F2), content: Image(systemName: "message.fill").foregroundStyle(.white).font(.system(size: 10)))
                }
                Text(AppStrings.Kids.statMostUsed)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
            .frame(maxWidth: .infinity)
            .padding(8)

            Color(hex: 0xF2F5F9).frame(width: 2, height: 56)

            VStack(spacing: 8) {
                Text(AppStrings.Kids.statPickupsValue)
                    .font(AppTypography.headingXsBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text(AppStrings.Kids.statPickups)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
            .frame(maxWidth: .infinity)
            .padding(8)

            Color(hex: 0xF2F5F9).frame(width: 2, height: 56)

            VStack(spacing: 8) {
                Text(AppStrings.Kids.statLastUsedValue)
                    .font(AppTypography.headingXsBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text(AppStrings.Kids.statLastUsed)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
            .frame(maxWidth: .infinity)
            .padding(8)
        }
        .padding(.vertical, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 4)
        )
    }

    @ViewBuilder
    private func appBadge<C: View>(bg: Color, content: C) -> some View {
        ZStack {
            Circle().fill(bg)
            content
        }
        .frame(width: 24, height: 24)
        .overlay(Circle().strokeBorder(Color.white, lineWidth: 1))
    }
}
