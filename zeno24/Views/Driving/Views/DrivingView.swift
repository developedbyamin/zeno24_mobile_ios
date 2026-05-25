import SwiftUI

struct DrivingView: View {
    @State private var segment: DrivingHeaderHero.Segment = .today
    @Environment(\.tabBarHeight) private var tabBarHeight
    @Environment(\.isTabActive) private var isTabActive

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 4) {
                    VStack(spacing: 16) {
                        DrivingHeaderHero(segment: $segment)
                        DrivingStatsRow()
                        DrivingSummaryRows()
                    }
                    .padding(.vertical, 12)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                    DrivingMemberCard(avatar: AppImages.avatarNigar,  name: AppStrings.Driving.memberNigar,  risksLabel: AppStrings.Driving.risks2)
                    DrivingMemberCard(avatar: AppImages.avatarFiruza, name: AppStrings.Driving.memberFiruza, risksLabel: AppStrings.Driving.risks1)

                    Color.clear.frame(height: 80)
                }
            }
            .background(Color(hex: 0xF6F6F6).ignoresSafeArea())

            if isTabActive {
                CirclePill(fallbackTitle: AppStrings.Driving.circleName)
                    .padding(.bottom, tabBarHeight)
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            AppTopBar(title: AppStrings.Driving.title)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}
