import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    NotificationSectionHeader(title: AppStrings.Notifications.sectionToday)
                    todaySection

                    NotificationSectionHeader(title: AppStrings.Notifications.sectionYesterday)
                    yesterdaySection

                    NotificationSectionHeader(title: AppStrings.Notifications.sectionOlder)
                    olderSection

                    Color.clear.frame(height: 80)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .background(Color(hex: 0xF6F6F6).ignoresSafeArea())

            HStack {
                Spacer()
                NotificationsFAB()
                    .padding(.trailing, 16)
            }
            .overlay {
                CirclePill(fallbackTitle: AppStrings.Notifications.circleName)
            }
            .padding(.bottom, 14)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            AppTopBar(title: AppStrings.Notifications.title) { dismiss() }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Sections

    private var todaySection: some View {
        VStack(spacing: 0) {
            NotificationRow(
                title: "Fidan`s battrey is low",
                time: "17:00 PM",
                avatarBackground: Color(hex: 0xFF5F03),
                badgeColor: Color(hex: 0xF70505),
                badgeAsset: .vector(AppVectors.removeBattery)
            )
            rowDivider
            NotificationRow(
                title: "Narmin arrive at home",
                time: "19:00 PM",
                avatarAsset: AppImages.avatarNigar,
                badgeColor: Color(hex: 0x3DC562),
                badgeAsset: .vector(AppVectors.earth)
            )
            rowDivider
            NotificationRow(
                title: "Fidan leave school",
                time: "11:30 PM",
                avatarAsset: AppImages.avatarFidan,
                badgeColor: Color(hex: 0x3DC562),
                badgeAsset: .vector(AppVectors.earth)
            )
        }
        .padding(.horizontal, 8)
    }

    private var yesterdaySection: some View {
        VStack(spacing: 0) {
            NotificationRow(
                title: "Luna leave home",
                time: "12:00 PM",
                avatarBackground: Color(hex: 0xFFC7E0),
                badgeColor: AppColors.brand,
                badgeAsset: .systemImage("pawprint.fill")
            )
            rowDivider
            NotificationRow(
                title: "Fidan`s peak speed",
                time: "4h ago",
                avatarAsset: AppImages.avatarFiruza,
                badgeColor: Color(hex: 0x0088FF),
                badgeAsset: .vector(AppVectors.car)
            )
            rowDivider
            NotificationRow(
                title: "Fidan`s completed goal",
                time: "12 Dec 2025",
                avatarAsset: AppImages.avatarChatOther,
                badgeColor: Color(hex: 0xFF20B5),
                badgeAsset: .systemImage("sparkles")
            )
        }
        .padding(.horizontal, 8)
    }

    private var olderSection: some View {
        VStack(spacing: 0) {
            NotificationRow(
                title: "You strong with Premium 👑 😉",
                time: "20:00 PM",
                avatarAsset: AppImages.avatarNigar,
                badgeColor: Color(hex: 0xFF20B5),
                badgeAsset: .systemImage("sparkles")
            )
            rowDivider
            NotificationRow(
                title: "Narmin arrive at home",
                time: "19:00 PM",
                avatarAsset: AppImages.avatarNigar,
                badgeColor: Color(hex: 0xF70505),
                badgeAsset: .vector(AppVectors.removeBattery)
            )
            NotificationRow(
                title: "Fidan`s battrey is low",
                time: "12:00 PM",
                avatarAsset: AppImages.avatarFidan,
                badgeColor: Color(hex: 0xF70505),
                badgeAsset: .vector(AppVectors.removeBattery)
            )
            rowDivider
            NotificationRow(
                title: "Fidan`s battrey is low",
                time: "4h ago",
                avatarAsset: AppImages.avatarFiruza,
                badgeColor: Color(hex: 0xF70505),
                badgeAsset: .vector(AppVectors.removeBattery)
            )
            rowDivider
            NotificationRow(
                title: "Fidan`s battrey is low",
                time: "12 Dec 2025",
                avatarAsset: AppImages.avatarChatOther,
                badgeColor: Color(hex: 0xF70505),
                badgeAsset: .vector(AppVectors.removeBattery)
            )
        }
        .padding(.horizontal, 8)
    }

    private var rowDivider: some View {
        HStack {
            Spacer()
            Color(hex: 0xF2F5F9).frame(height: 1)
        }
        .frame(width: 291, height: 1)
    }
}
