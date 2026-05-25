import SwiftUI

/// Health dashboard — 1:1 port of Figma node 6040:13519.
struct HealthView: View {
    @State private var segment: HealthDailyStepsCard.Segment = .lastWeek
    @Environment(\.tabBarHeight) private var tabBarHeight

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 4) {
                HealthDailyStepsCard(segment: $segment)
                HealthChallengeCard()
                HealthMonthlySummaryCard()
                HealthMovingHistoryCard()
                Color.clear.frame(height: tabBarHeight + 16)
            }
        }
        .background(Color(hex: 0xF6F6F6).ignoresSafeArea())
        .navigationTitle(AppStrings.Health.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
