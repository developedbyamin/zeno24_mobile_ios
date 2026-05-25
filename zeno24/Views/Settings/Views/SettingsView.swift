import SwiftUI

struct SettingsView: View {
    @Environment(AuthStore.self) private var auth
    @Environment(\.tabBarHeight) private var tabBarHeight

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 4) {
                SettingsProfileCard(
                    onProfileTap: { },
                    onUpgradeTap: { }
                )

                SettingsMenuCard {
                    SettingsRow(asset: AppVectors.threeUser,     title: AppStrings.Settings.manageCircle,         tint: Color(hex: 0x3DC562))
                    SettingsRow(asset: AppVectors.notification2, title: AppStrings.Settings.notificationSettings, tint: Color(hex: 0xFF5F03))
                    SettingsRow(asset: AppVectors.lockOpen,      title: AppStrings.Settings.permissions,          tint: Color(hex: 0xEB6659))
                    SettingsRow(asset: AppVectors.shieldDone,    title: AppStrings.Settings.onRoadSafety,         tint: Color(hex: 0x0088FF))
                }

                SettingsMenuCard {
                    SettingsRow(asset: AppVectors.messageChatHeart,   title: AppStrings.Settings.shareFeedback,    tint: Color(hex: 0xFF5F03))
                    SettingsRow(asset: AppVectors.store,              title: AppStrings.Settings.restorePurchases, tint: AppColors.brand)
                    SettingsRow(asset: AppVectors.share,              title: AppStrings.Settings.shareWithFriends, tint: Color(hex: 0x0088FF))
                    SettingsRow(asset: AppVectors.questionMarkCircle, title: AppStrings.Settings.privacyPolicy,    tint: Color(hex: 0xFFCC00))
                    SettingsRow(asset: AppVectors.logout,             title: AppStrings.Settings.logout,           tint: Color(hex: 0xEB6659)) {
                        Task { await auth.logout() }
                    }
                }

                Color.clear.frame(height: tabBarHeight + 16)
            }
        }
        .background(Color(hex: 0xF6F6F6).ignoresSafeArea())
        .navigationTitle(AppStrings.Settings.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
