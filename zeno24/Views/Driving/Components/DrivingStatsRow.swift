import SwiftUI

struct DrivingStatsRow: View {
    var body: some View {
        HStack(spacing: 0) {
            stat(big: "24", small: nil, label: AppStrings.Driving.statDriveCount)
            Color(hex: 0xF2F5F9).frame(width: 2, height: 56)
            stat(big: "82,6", small: "km", label: AppStrings.Driving.statDistance)
            Color(hex: 0xF2F5F9).frame(width: 2, height: 56)
            stat(big: "120", small: "km/h", label: AppStrings.Driving.statMaxSpeed)
        }
        .padding(.vertical, 8)
        .frame(width: 343)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 3)
        )
    }

    private func stat(big: String, small: String?, label: String) -> some View {
        VStack(spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(big)
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundStyle(AppColors.mainBlack)
                if let small {
                    Text(small)
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(AppColors.mainBlack)
                }
            }
            Text(label)
                .font(AppTypography.bodyXsMedium)
                .foregroundStyle(Color(hex: 0x8B98A8))
        }
        .frame(maxWidth: .infinity)
        .padding(8)
    }
}
