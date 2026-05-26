import SwiftUI

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

@MainActor
struct AppRouteBuilder {
    @ViewBuilder
    static func view(for route: AppRoute) -> some View {
        switch route {
        case .messages:              MessagesView()
        case .chat(let thread):      ChatView(thread: thread)
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
