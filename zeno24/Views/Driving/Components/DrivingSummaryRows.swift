import SwiftUI

struct DrivingSummaryRows: View {
    var body: some View {
        VStack(spacing: 0) {
            Text(AppStrings.Driving.circleSummary)
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(Color(hex: 0x8B98A8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color(hex: 0xF8F7FF))

            VStack(spacing: 8) {
                row(color: Color(hex: 0x0088FF),  asset: AppVectors.flash,          label: AppStrings.Driving.peakSpeed)
                divider
                row(color: Color(hex: 0x3DC562),  asset: AppVectors.stopwatchSpeed, label: AppStrings.Driving.suddenSpeedUp)
                divider
                row(color: Color(hex: 0xFFCC00),  asset: AppImages.emojiSharpStop,  label: AppStrings.Driving.sharpStop, isImage: true)
                divider
                row(color: AppColors.brand,        asset: AppVectors.phoneVibrate,   label: AppStrings.Driving.distractions)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
        }
    }

    private var divider: some View {
        HStack { Spacer(); Color(hex: 0xF2F5F9).frame(height: 1); Spacer() }
            .frame(width: 291, height: 1)
    }

    private func row(color: Color, asset: String, label: String, isImage: Bool = false) -> some View {
        HStack {
            HStack(spacing: 8) {
                ZStack {
                    Circle().fill(color)
                    if isImage {
                        Image(asset)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    } else {
                        Image(asset)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 28, height: 28)

                Text(label)
                    .font(AppTypography.bodySmSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
            }
            Spacer()
            Image(AppVectors.lock)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundStyle(AppColors.mainBlack)
                .frame(width: 28, height: 28)
                .background(Color(hex: 0xF8F7FF), in: Circle())
        }
    }
}
