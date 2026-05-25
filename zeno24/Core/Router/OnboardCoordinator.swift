import SwiftUI

struct OnboardCoordinator: View {
    @State private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            OnboardView()
                .navigationDestination(for: AppRoute.self) { route in
                    AppRouteBuilder.view(for: route)
                }
        }
        .environment(router)
    }
}
