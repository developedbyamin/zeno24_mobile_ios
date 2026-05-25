import SwiftUI

struct HealthMovingHistoryCard: View {
    var body: some View {
        VStack(spacing: 12) {
            // Purple sub-header
            Text(AppStrings.Health.movingHistory)
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(Color(hex: 0x8B98A8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color(hex: 0xF8F7FF))

            tripCard(chips: [
                .init(image: AppImages.emojiClock2, text: "20 min"),
                .init(image: AppImages.emojiRunning, text: "2,5 km"),
            ], showAlerts: true, leftChip: nil)

            tripCard(chips: [
                .init(image: AppImages.emojiClock2, text: "20 min"),
                .init(image: AppImages.emojiCar,    text: "2,5 km"),
            ], showAlerts: false, leftChip: .init(image: AppImages.emojiSpeed, text: "50 km/h"))
        }
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private struct Chip {
        let image: String
        let text: String
    }

    @ViewBuilder
    private func tripCard(chips: [Chip], showAlerts: Bool, leftChip: Chip?) -> some View {
        VStack(spacing: 12) {
            mapBox(chips: chips, showAlerts: showAlerts, leftChip: leftChip)
            timeline
        }
        .frame(width: 343)
    }

    @ViewBuilder
    private func mapBox(chips: [Chip], showAlerts: Bool, leftChip: Chip?) -> some View {
        ZStack {
            Image(AppImages.kidsMap)
                .resizable()
                .scaledToFill()
                .frame(height: 176)
                .frame(maxWidth: .infinity)
                .clipped()
                .background(Color(hex: 0xF6F7F9))

            // Polyline (purple dashed line approximation)
            Path { path in
                path.move(to: CGPoint(x: 67, y: 30))
                path.addCurve(
                    to: CGPoint(x: 246, y: 130),
                    control1: CGPoint(x: 130, y: 50),
                    control2: CGPoint(x: 180, y: 110)
                )
            }
            .stroke(AppColors.brand, style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6, 4]))

            // Start glow + end glow
            Circle().fill(AppColors.brand).frame(width: 12, height: 12)
                .overlay(Circle().stroke(AppColors.brand.opacity(0.3), lineWidth: 8))
                .position(x: 74, y: 36)
            Circle().fill(Color(hex: 0xFF5F03)).frame(width: 12, height: 12)
                .overlay(Circle().stroke(Color(hex: 0xFF5F03).opacity(0.3), lineWidth: 8))
                .position(x: 246, y: 130)

            // Get Alerts chip top-left
            if showAlerts {
                HStack(spacing: 6) {
                    ZStack {
                        Circle().fill(AppColors.brand).frame(width: 24, height: 24)
                        Image(AppVectors.ringing)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.white)
                    }
                    Text(AppStrings.Health.getAlerts)
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(AppColors.mainBlack)
                        .padding(.trailing, 12)
                }
                .background(Color.white, in: Capsule())
                .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.05), radius: 4, x: 0, y: 1)
                .position(x: 70, y: 22)
            }

            // Bottom chips
            HStack(spacing: 8) {
                if let leftChip {
                    chipPill(image: leftChip.image, text: leftChip.text)
                    Spacer()
                } else {
                    Spacer()
                }
                ForEach(Array(chips.enumerated()), id: \.offset) { _, chip in
                    chipPill(image: chip.image, text: chip.text)
                }
            }
            .padding(.horizontal, 8)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 8)
        }
        .frame(height: 176)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func chipPill(image: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Text(text)
                .font(AppTypography.bodyXsBold)
                .foregroundStyle(AppColors.mainBlack)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white, in: Capsule())
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.05), radius: 4, x: 0, y: 1)
    }

    private var timeline: some View {
        HStack(spacing: 20) {
            VStack(spacing: 0) {
                Circle().fill(AppColors.brand).frame(width: 12, height: 12)
                    .overlay(Circle().stroke(AppColors.brand.opacity(0.2), lineWidth: 4))
                Color(hex: 0xF2F5F9).frame(width: 1, height: 16)
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: 0xFF5F03))
            }
            VStack(spacing: 12) {
                HStack {
                    Text(AppStrings.Health.address1)
                        .font(AppTypography.bodySmSemiBold)
                        .foregroundStyle(AppColors.mainBlack)
                    Spacer()
                    Text(AppStrings.Health.time1)
                        .font(AppTypography.bodyXsMedium)
                        .foregroundStyle(Color(hex: 0x8B98A8))
                }
                Color(hex: 0xF8F7FF).frame(height: 1)
                HStack {
                    Text(AppStrings.Health.address2)
                        .font(AppTypography.bodySmSemiBold)
                        .foregroundStyle(AppColors.mainBlack)
                    Spacer()
                    Text(AppStrings.Health.time2)
                        .font(AppTypography.bodyXsMedium)
                        .foregroundStyle(Color(hex: 0x8B98A8))
                }
            }
        }
        .padding(.horizontal, 12)
    }
}
