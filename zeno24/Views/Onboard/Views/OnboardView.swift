import SwiftUI

struct OnboardView: View {
    @Environment(AuthStore.self) private var auth
    @State private var splashVisible: Bool = !Self.hasShownSplash
    @State private var isActive: Bool = true

    private static var hasShownSplash: Bool = false

    private let titles = [
        AppStrings.Onboard.slide1,
        AppStrings.Onboard.slide2,
        AppStrings.Onboard.slide3,
    ]

    var body: some View {
        @Bindable var auth = auth
        ZStack {
            OnboardVideoBackground(isPlaying: isActive)

            OnboardBottomGradient()

            content(auth: auth)
                .offset(y: splashVisible ? 40 : 0)
                .opacity(splashVisible ? 0 : 1)
                .animation(.easeOut(duration: 0.5), value: splashVisible)

            OnboardSplashOverlay(isVisible: splashVisible)
        }
        .background(AppColors.mainBlack.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            isActive = true
            if splashVisible {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    splashVisible = false
                    Self.hasShownSplash = true
                }
            }
        }
        .onDisappear { isActive = false }
    }

    @ViewBuilder
    private func content(auth: AuthStore) -> some View {
        VStack(spacing: 20) {
            OnboardCarousel(titles: titles)
            OnboardBottomSection(store: auth) {
                auth.finishOnboarding()
            }
            .padding(.horizontal, 16)
        }
    }
}

