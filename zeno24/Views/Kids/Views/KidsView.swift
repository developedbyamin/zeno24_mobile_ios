import SwiftUI

struct KidsView: View {
    @Environment(\.tabBarHeight) private var tabBarHeight

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 4) {
                    KidsProfileCard()
                    KidsPromoActionsCard()
                    KidsLiveLocationCard()
                    KidsScreenTimeCard()
                    KidsUsedAppsCard()
                    Color.clear.frame(height: tabBarHeight + 64)
                }
            }
            .background(Color(hex: 0xF6F6F6).ignoresSafeArea())

            KidsBoardPill()
                .padding(.bottom, tabBarHeight + 16)
        }
        .navigationTitle(AppStrings.Kids.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
