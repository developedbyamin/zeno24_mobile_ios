import SwiftUI

/// Bottom-tab shell for the authenticated experience — Figma `4991:14591`.
///
/// Five tabs (Home / Kids / Driving / Health / Premium) over a custom
/// translucent bar that matches Figma 1:1. Each tab owns its own
/// `NavigationStack` + `AppRouter`, so push state survives a tab switch
/// — same behaviour as Apple's stock apps. Tapping an already-selected
/// tab pops that tab's stack back to root.
struct MainView: View {
    @State private var selectedTab: AppTab = .home
    @State private var tabBarHeight: CGFloat = 0

    @State private var homeRouter    = AppRouter()
    @State private var kidsRouter    = AppRouter()
    @State private var drivingRouter = AppRouter()
    @State private var healthRouter  = AppRouter()
    @State private var premiumRouter = AppRouter()

    var body: some View {
        ZStack {
            tabRoot(.home,    router: homeRouter)    { HomeView() }
            tabRoot(.kids,    router: kidsRouter)    { KidsView() }
            tabRoot(.driving, router: drivingRouter) { DrivingView() }
            tabRoot(.health,  router: healthRouter)  { HealthView() }
            tabRoot(.premium, router: premiumRouter) { PremiumView() }
        }
        .environment(\.tabBarHeight, tabBarHeight)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            MainTabBar(selection: $selectedTab) { tab in
                router(for: tab).popToRoot()
            }
            .reportTabBarHeight()
        }
        .onPreferenceChange(TabBarHeightPreferenceKey.self) { tabBarHeight = $0 }
    }

    // MARK: - Helpers

    private func router(for tab: AppTab) -> AppRouter {
        switch tab {
        case .home:    return homeRouter
        case .kids:    return kidsRouter
        case .driving: return drivingRouter
        case .health:  return healthRouter
        case .premium: return premiumRouter
        }
    }

    @ViewBuilder
    private func tabRoot<Content: View>(
        _ tab: AppTab,
        router: AppRouter,
        @ViewBuilder content: () -> Content
    ) -> some View {
        @Bindable var router = router
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: AppRoute.self) { route in
                    AppRouteBuilder.view(for: route)
                }
        }
        .environment(router)
        .opacity(selectedTab == tab ? 1 : 0)
        .allowsHitTesting(selectedTab == tab)
    }
}

// MARK: - Tab model

enum AppTab: Int, CaseIterable, Identifiable {
    case home, kids, driving, health, premium
    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home:    return AppStrings.Tab.home
        case .kids:    return AppStrings.Tab.kids
        case .driving: return AppStrings.Tab.driving
        case .health:  return AppStrings.Tab.health
        case .premium: return AppStrings.Tab.premium
        }
    }

    var iconAsset: String {
        switch self {
        case .home:    return AppVectors.home
        case .kids:    return AppVectors.sleeping
        case .driving: return AppVectors.car
        case .health:  return AppVectors.heart
        case .premium: return AppVectors.gem
        }
    }
}
