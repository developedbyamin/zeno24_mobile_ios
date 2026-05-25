import SwiftUI

struct DrivingHeaderHero: View {
    @Binding var segment: Segment

    enum Segment { case today, week }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(AppImages.safeDriveIllustration)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 206, height: 143)

                Text(AppStrings.Driving.reportTitle)
                    .font(AppTypography.headingXsBold)
                    .foregroundStyle(AppColors.mainBlack)

                Text(AppStrings.Driving.reportSubtitle)
                    .font(AppTypography.bodySmMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
                    .multilineTextAlignment(.center)
                    .frame(width: 271)
            }

            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    segmentButton(.today, label: AppStrings.Driving.segmentToday)
                    segmentButton(.week,  label: AppStrings.Driving.segmentWeek)
                }
                .padding(4)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .overlay(Capsule().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 1))

                HStack(spacing: 8) {
                    Image(AppVectors.timeCircle)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(AppColors.mainBlack)
                        .frame(width: 36, height: 36)
                        .background(Color(hex: 0xF2F5F9), in: Capsule())
                    Text(AppStrings.Driving.dateRange)
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(AppColors.mainBlack)
                }
                .padding(.leading, 4)
                .padding(.trailing, 8)
                .frame(height: 44)
                .overlay(Capsule().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 1))
            }
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func segmentButton(_ value: Segment, label: String) -> some View {
        let isActive = segment == value
        Button {
            segment = value
        } label: {
            Text(label)
                .font(AppTypography.bodyXsBold)
                .foregroundStyle(isActive ? .white : AppColors.mainBlack)
                .frame(maxWidth: .infinity)
                .frame(height: 32)
                .background(isActive ? Color(hex: 0x121212) : .clear, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}
