import SwiftUI

struct DrivingMemberCard: View {
    let avatar: String
    let name: String
    let risksLabel: String

    var body: some View {
        ZStack {
            // Inner white card with content (blurred behind locked overlay)
            HStack(spacing: 12) {
                Image(avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(Color.white, lineWidth: 4))
                    .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 4, x: 0, y: 1)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(name)
                                .font(AppTypography.headingXsBold)
                                .foregroundStyle(AppColors.mainBlack)

                            HStack(spacing: 6) {
                                Text(AppStrings.Driving.drivesLabel)
                                    .font(AppTypography.bodySmSemiBold)
                                    .foregroundStyle(Color(hex: 0x292D32))
                                Circle().fill(Color(hex: 0x292D32)).frame(width: 4, height: 4)
                                Text(AppStrings.Driving.kilometresLabel)
                                    .font(AppTypography.bodySmSemiBold)
                                    .foregroundStyle(Color(hex: 0x292D32))
                            }
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(AppColors.mainBlack)
                    }

                    HStack(spacing: 10) {
                        Spacer()
                        risksPill
                        smallChip(asset: AppVectors.flash, bg: Color(hex: 0xF2F5F9))
                        smallChip(image: AppImages.emojiSharpStop, bg: Color(hex: 0xF2F5F9))
                        smallChip(asset: AppVectors.phoneVibrate, bg: Color(hex: 0xF2F5F9))
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .blur(radius: 4)

            // Lock overlay
            Color.white.opacity(0.35)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Image(AppVectors.lock)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(AppColors.brand)
                .frame(width: 40, height: 40)
                .background(Color.white, in: Circle())
                .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .frame(height: 116)
        .padding(4)
        .background(Color(hex: 0xF8F7FF), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
    }

    private var risksPill: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle().fill(Color(hex: 0xFFCC00))
                Image(AppVectors.danger)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.white)
            }
            .frame(width: 24, height: 24)

            Text(risksLabel)
                .font(AppTypography.bodyXsBold)
                .foregroundStyle(AppColors.mainBlack)
        }
        .padding(.trailing, 8)
        .background(Color(hex: 0xF2F5F9), in: Capsule())
    }

    private func smallChip(asset: String? = nil, image: String? = nil, bg: Color) -> some View {
        ZStack {
            Circle().fill(bg)
            if let asset {
                Image(asset)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(AppColors.mainBlack)
            } else if let image {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
        }
        .frame(width: 28, height: 28)
    }
}
