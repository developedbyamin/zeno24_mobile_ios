import SwiftUI

struct RootView: View {
    @Environment(AuthStore.self) private var authStore

    var body: some View {
        ZStack(alignment: .top) {
            switch authStore.state {
            case .loading:        SplashView()
            case .unauthenticated: AuthCoordinator()
            case .authenticated:  MainView()
            }

            OverlayBanner()
        }
    }
}
