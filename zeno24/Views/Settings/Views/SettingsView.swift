import SwiftUI

struct SettingsView: View {
    @Environment(AuthStore.self) private var auth
    @Environment(SettingsStore.self) private var settings
    @Environment(\.dismiss) private var dismiss
    @State private var isConfirmingLogout = false
    @State private var isLoggingOut = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 4) {
                SettingsProfileCard(
                    name: settings.displayName,
                    email: settings.displayEmail,
                    isLoading: settings.isLoading && !settings.hasLoaded,
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
                        withAnimation(.easeOut(duration: 0.22)) {
                            isConfirmingLogout = true
                        }
                    }
                }

                Color.clear.frame(height: 16)
            }
        }
        .background(Color(hex: 0xF6F6F6).ignoresSafeArea())
        .appTopBar(title: AppStrings.Settings.title, onBack: { dismiss() })
        .onAppear {
            // Detached Task — `.task { ... }` ties the request lifetime to the
            // view, and SwiftUI cancels it (URLError -999) whenever the
            // parent re-renders (e.g. the locale `.id(...)` flip in
            // `zeno24App`). Firing from `onAppear` lets the load complete
            // independently of view recomposition.
            guard !settings.hasLoaded && !settings.isLoading else { return }
            Task { await settings.load() }
        }
        .refreshable { await settings.load() }
        .overlay {
            if isConfirmingLogout {
                LogoutConfirmDialog(
                    isPresented: $isConfirmingLogout,
                    isLoading: isLoggingOut,
                    onConfirm: performLogout
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }

    private func performLogout() {
        guard !isLoggingOut else { return }
        Task {
            isLoggingOut = true
            Haptics.notify(.success)
            await auth.logout()
            // Cached account / circle / member state is cleared by
            // `BootstrapStore.reset()`, which `RootView` invokes when
            // `auth.state` transitions to `.unauthenticated`.
            isLoggingOut = false
            withAnimation(.easeIn(duration: 0.18)) {
                isConfirmingLogout = false
            }
        }
    }
}
