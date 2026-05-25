import SwiftUI

/// Driving safety dashboard — 1:1 port of Figma node 6406:2183.
struct DrivingView: View {
    @State private var segment: DrivingHeaderHero.Segment = .today
    @Environment(\.tabBarHeight) private var tabBarHeight

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

                    Color.clear.frame(height: tabBarHeight + 64)
                }
            }
            .background(Color(hex: 0xF6F6F6).ignoresSafeArea())

            DrivingCirclePill()
                .padding(.bottom, tabBarHeight + 16)
        }
        .navigationTitle(AppStrings.Driving.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
