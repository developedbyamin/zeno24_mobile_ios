import SwiftUI

/// First-launch marketing screen — 1:1 Figma node `3682:6013`.
///
/// Figma frame is 375 × 812 with these vertical landmarks:
///   • Carousel        y=457, height=128
///   • Bottom card     y=581, height=198 (ends at y=779)
///   • Home indicator  y=779, height=33
///
/// To stay 1:1 on a 375-pt wide canvas we anchor the card to the bottom
/// with a 33-pt safe gap (matches the Figma home-indicator slot) and
/// place the carousel directly above it with the same 4-pt overlap-bleed
/// that exists in the design.
struct OnboardView: View {
    @Environment(AuthStore.self) private var auth
    /// True only on the very first appearance of the view in this app launch.
    /// Returning from the sign-in flow must NOT replay the splash.
    @State private var splashVisible: Bool = !Self.hasShownSplash
    @State private var isActive: Bool = true

    /// Static so the flag persists across `OnboardView` instances within
    /// the same app launch (re-mounts when RootView switches back).
    private static var hasShownSplash: Bool = false

    private let titles = [
        AppStrings.Onboard.slide1,
        AppStrings.Onboard.slide2,
        AppStrings.Onboard.slide3,
    ]

    var body: some View {
        @Bindable var auth = auth
        ZStack {
            // 1 — video (paused as soon as the view disappears so the
            // RootView crossfade has no decoding cost to fight)
            OnboardVideoBackground(isPlaying: isActive)

            // 2 — bottom-anchored gradient
            OnboardBottomGradient()

            // 3 — content
            content(auth: auth)
                .offset(y: splashVisible ? 40 : 0)
                .opacity(splashVisible ? 0 : 1)
                .animation(.easeOut(duration: 0.5), value: splashVisible)

            // 4 — splash
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
        VStack(spacing: 20) {                     // dots → CTA: 20pt
            OnboardCarousel(titles: titles)       // takes all the slack
            OnboardBottomSection(store: auth) {
                auth.finishOnboarding()
            }
            .padding(.horizontal, 16)
        }
    }
}

