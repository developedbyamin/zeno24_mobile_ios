import SwiftUI

struct RootView: View {
    @Environment(AuthStore.self) private var authStore
    @Environment(BootstrapStore.self) private var bootstrap
    @Environment(PremiumStore.self) private var premium
    @State private var router = AppRouter()

    var body: some View {
        @Bindable var router = router

        ZStack(alignment: .top) {
            switch authStore.state {
            case .loading:
                SplashView()
            case .unauthenticated:
                AuthCoordinator()
                    .onAppear {
                        bootstrap.reset()
                        // Logging out (or any drop back to .unauthenticated)
                        // must wipe the in-app NavigationStack — otherwise
                        // the next sign-in lands the user on whatever screen
                        // they were on before (e.g. Settings) instead of the
                        // tab root.
                        router.popToRoot()
                    }
            case .authenticated:
                if bootstrap.state == .ready {
                    // Single root-level NavigationStack. `router.push(.messages)`
                    // from anywhere inside the tab shell pushes a new screen
                    // ON TOP of the entire shell — tab bar isn't part of the
                    // pushed view, so it naturally disappears (no hide/show
                    // logic).
                    NavigationStack(path: $router.path) {
                        CircleFlowHost {
                            MainView()
                        }
                        .navigationDestination(for: AppRoute.self) { route in
                            AppRouteBuilder.view(for: route)
                        }
                    }
                    .environment(self.router)
                } else {
                    // Cold launch (token already in keychain) — no auth view
                    // to keep on screen, so the splash is the only graceful
                    // surface while `/main/settings`, `/circles/list`, and
                    // the marker sync warm up. The fresh-sign-in path takes
                    // a different branch: see `signInThroughBootstrap` in
                    // AuthStore — it runs bootstrap *before* flipping
                    // `state` to `.authenticated`, so the user never sees
                    // this splash after tapping Apple/Google/OTP.
                    SplashView()
                        .onAppear { bootstrap.start() }
                }
            }

            // Premium sheet + outcome dialog sit above EVERY route — tabs,
            // auth, splash — because `PremiumStore` is owned by `zeno24App`
            // and lives for the whole app lifetime. Anywhere that calls
            // `premium.presentSheet(...)` or `premium.presentOutcomeDialog()`
            // surfaces them globally without remounting per-tab.
            if premium.isSheetVisible {
                PremiumSheet(
                    isPresented: Binding(
                        get: { premium.isSheetVisible },
                        set: { if !$0 { premium.dismiss() } }
                    ),
                    onStartTrial: { _ in
                        // Defer outcome until the sheet's slide-down finishes
                        // so the dialog lands on a clean presenter.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            premium.presentOutcomeDialog()
                        }
                    }
                )
                .zIndex(2000)
            }

            if let variant = premium.outcome {
                PremiumOutcomeDialog(
                    isPresented: Binding(
                        get: { premium.outcome != nil },
                        set: { if !$0 { premium.dismissOutcome() } }
                    ),
                    variant: variant,
                    onTryAgain: { premium.presentOutcomeDialog() }
                )
                .zIndex(2100)
            }

            OverlayBanner()
        }
    }
}
