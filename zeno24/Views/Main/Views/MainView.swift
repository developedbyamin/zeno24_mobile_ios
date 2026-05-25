import SwiftUI

/// Authenticated tab shell — just five tab roots and a bottom `MainTabBar`.
/// Navigation is owned by the root `NavigationStack` in `RootView`, so any
/// `router.push(...)` from a tab pushes the new screen above this shell,
/// hiding the tab bar naturally (no manual visibility toggles).
struct MainView: View {
    @State private var selectedTab: AppTab = .home
    @State private var tabBarHeight: CGFloat = 0
    @Environment(AppRouter.self) private var router

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                tabRoot(.home)    { HomeView() }
                tabRoot(.kids)    { KidsView() }
                tabRoot(.driving) { DrivingView() }
                tabRoot(.health)  { HealthView() }
                tabRoot(.premium) { PremiumView() }
            }
            .environment(\.tabBarHeight, tabBarHeight)
            MainTabBar(selection: $selectedTab) { _ in
                router.popToRoot()
            }
            .background(
                GeometryReader { proxy in
                    let total = proxy.size.height + proxy.safeAreaInsets.bottom
                    Color.clear.task(id: total) {
                        tabBarHeight = total
                    }
                }
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    @ViewBuilder
    private func tabRoot<Content: View>(
        _ tab: AppTab,
        @ViewBuilder content: () -> Content
    ) -> some View {
        let isActive = selectedTab == tab
        content()
            .environment(\.isTabActive, isActive)
            .opacity(isActive ? 1 : 0)
            .allowsHitTesting(isActive)
    }
}

