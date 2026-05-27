import SwiftUI

struct KidsView: View {
    @Environment(\.tabBarHeight) private var tabBarHeight
    @Environment(\.isTabActive) private var isTabActive

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 4) { 
                    KidsProfileCard()
                    KidsPromoActionsCard()
                    KidsLiveLocationCard()
                    KidsScreenTimeCard()
                    KidsUsedAppsCard()
                    Color.clear.frame(height: tabBarHeight + 16)
                }
            }
            .background(Color(hex: 0xF6F6F6).ignoresSafeArea())
            if isTabActive {
                CirclePill(fallbackTitle: AppStrings.Driving.circleName)
                    .padding(.bottom, tabBarHeight)
            }
        }
        .appTopBar(title: AppStrings.Kids.title, bottomCornerRadius: 16, spacing: 8)
    }
}
