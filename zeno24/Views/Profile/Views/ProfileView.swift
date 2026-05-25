import SwiftUI

struct ProfileView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(AuthStore.self) private var auth
    @Environment(AppRouter.self) private var router

    @State private var isConfirmingLogout = false
    @State private var isLoggingOut = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ProfileHeader(account: settings.account)
                }

                Section {
                    NavigationLink(value: AppRoute.settings) {
                        Label(AppStrings.Profile.settings, systemImage: AppIcons.settings)
                    }
                    NavigationLink(value: AppRoute.premium) {
                        Label(AppStrings.Profile.premium, systemImage: "crown")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        Haptics.selection()
                        isConfirmingLogout = true
                    } label: {
                        HStack {
                            Label(AppStrings.Profile.logout, systemImage: "rectangle.portrait.and.arrow.right")
                            Spacer()
                            if isLoggingOut {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(isLoggingOut)
                }
            }
            .navigationTitle(AppStrings.Tab.profile)
            .task { await settings.load() }
            .confirmationDialog(
                AppStrings.Profile.logoutConfirmTitle,
                isPresented: $isConfirmingLogout,
                titleVisibility: .visible
            ) {
                Button(AppStrings.Profile.logout, role: .destructive) {
                    performLogout()
                }
                Button(AppStrings.Profile.cancel, role: .cancel) {}
            } message: {
                Text(AppStrings.Profile.logoutConfirmMessage)
            }
        }
    }

    private func performLogout() {
        Task {
            isLoggingOut = true
            Haptics.notify(.success)
            await auth.logout()
            isLoggingOut = false
        }
    }
}
