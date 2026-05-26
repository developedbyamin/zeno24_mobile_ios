import SwiftUI

struct HealthView: View {
    @State private var segment: HealthDailyStepsCard.Segment = .lastWeek
    @Environment(\.tabBarHeight) private var tabBarHeight
    @Environment(\.isTabActive) private var isTabActive

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 4) {
                    HealthDailyStepsCard(segment: $segment)
                    HealthChallengeCard()
                    HealthMonthlySummaryCard()
                    HealthMovingHistoryCard()
                    Color.clear.frame(height: 80)
                }
            }
            .background(Color(hex: 0xF6F6F6).ignoresSafeArea())

            if isTabActive {
                CirclePill(fallbackTitle: AppStrings.Driving.circleName)
                    .padding(.bottom, tabBarHeight)
            }
        }
        .appTopBar(title: AppStrings.Health.title, bottomCornerRadius: 16, spacing: 8)
    }
}
