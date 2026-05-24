import SwiftUI

/// Centralized navigation state — mirrors app_router.dart (go_router).
/// Provides a single NavigationPath; views push/pop via `router.push(...)`.
@MainActor
@Observable
final class AppRouter {
    var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func replace(with route: AppRoute) {
        path = NavigationPath()
        path.append(route)
    }
}

/// Builds the destination view for a given AppRoute.
@MainActor
struct AppRouteBuilder {
    @ViewBuilder
    static func view(for route: AppRoute) -> some View {
        switch route {
        case .home:                  HomeView()
        case .messages:              MessagesView()
        case .chat(let circleId):    ChatView(circleId: circleId)
        case .notifications:         NotificationsView()
        case .profile:               ProfileView()
        case .settings:              SettingsView()

        case .health:                HealthView()
        case .kids:                  KidsView()
        case .driving:               DrivingView()
        case .premium:               PremiumView()
        }
    }
}
