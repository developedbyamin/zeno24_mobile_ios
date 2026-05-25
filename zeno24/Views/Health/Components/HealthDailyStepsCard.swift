import SwiftUI

struct HealthDailyStepsCard: View {
    @Binding var segment: Segment

    enum Segment { case lastWeek, yesterday, today }

    var body: some View {
        VStack(spacing: 12) {
            segmentedControl
                .padding(.horizontal, 16)

            ZStack {
                stepsRing
                stepsCenter
                changeGoalPill
                    .offset(y: 78)
            }
            .frame(height: 188)

            statsRow
                .padding(.horizontal, 8)

            motivationBanner
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Segmented control

    private var segmentedControl: some View {
        HStack(spacing: 0) {
            segmentButton(.lastWeek,  label: AppStrings.Health.segLastWeek)
            segmentButton(.yesterday, label: AppStrings.Health.segYesterday)
            Color(hex: 0xF2F5F9).frame(width: 1, height: 32)
            segmentButton(.today,     label: AppStrings.Health.segToday)
        }
        .padding(4)
        .frame(height: 44)
        .overlay(Capsule().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 1))
    }

    private func segmentButton(_ value: Segment, label: String) -> some View {
        let isActive = segment == value
        return Button {
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

    // MARK: - Steps ring

    private var stepsRing: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: 0xF2F5F9), lineWidth: 14)
                .frame(width: 158, height: 158)
            Circle()
                .trim(from: 0, to: 0.45)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: 0xCF81FF), Color(hex: 0x9E7FFF)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 158, height: 158)
            Circle()
                .fill(Color(hex: 0xCF81FF))
                .frame(width: 8, height: 8)
                .offset(x: 79, y: 0)
                .rotationEffect(.degrees(-90 + 360 * 0.45))
        }
    }

    private var stepsCenter: some View {
        VStack(spacing: 8) {
            Text(AppStrings.Health.dailySteps)
                .font(AppTypography.bodyXsMedium)
                .foregroundStyle(Color(hex: 0x8B98A8))
            Text(AppStrings.Health.stepsValue)
                .font(AppTypography.heading2XlBold)
                .foregroundStyle(AppColors.mainBlack)
            Text(AppStrings.Health.stepsTotal)
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(Color(hex: 0x8B98A8))
        }
    }

    private var changeGoalPill: some View {
        Button {
        } label: {
            HStack(spacing: 4) {
                Text(AppStrings.Health.changeGoal)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(.white)
                Image(AppVectors.pen)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(hex: 0x121212), in: Capsule())
            .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 16, x: 0, y: 16)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Stats row

    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem(asset: AppVectors.journey, tint: Color(hex: 0x0088FF), bg: Color(hex: 0x0088FF).opacity(0.06),
                     value: AppStrings.Health.distanceValue, label: AppStrings.Health.totalDistance)
            Color(hex: 0xF2F5F9).frame(width: 1, height: 76)
            statItem(asset: AppVectors.fire, tint: Color(hex: 0xFF5F03), bg: Color(hex: 0xFF5F03).opacity(0.06),
                     value: AppStrings.Health.caloriesValue, label: AppStrings.Health.calories)
            Color(hex: 0xF2F5F9).frame(width: 1, height: 76)
            statItem(asset: AppVectors.circleClock, tint: Color(hex: 0x3DC562), bg: Color(hex: 0x3DC562).opacity(0.08),
                     value: AppStrings.Health.activeTimeValue, label: AppStrings.Health.activeTime)
        }
    }

    private func statItem(asset: String, tint: Color, bg: Color, value: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(asset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
                .background(bg, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            VStack(spacing: 6) {
                Text(value)
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text(label)
                    .font(AppTypography.bodyXsMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
    }

    // MARK: - Motivation banner

    private var motivationBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x9E7FFF), Color(hex: 0xCF81FF)],
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
                    Text(AppStrings.Health.motivationLine1)
                    Text(AppStrings.Health.motivationLine2)
                }
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(.white)
                .padding(.leading, 16)

                Spacer(minLength: 0)

                Button {
                } label: {
                    Text(AppStrings.Health.createHabit)
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
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .frame(width: 343)
    }
}
