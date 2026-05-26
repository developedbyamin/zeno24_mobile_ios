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
                    .onAppear { bootstrap.reset() }
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
