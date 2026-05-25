import SwiftUI

struct AuthCoordinator: View {
    @Environment(AuthStore.self) private var auth

    var body: some View {
        @Bindable var auth = auth
        NavigationStack(path: $auth.authPath) {
            OnboardView()
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .sign:       SignView()
                    case .otp:        OtpView()
                    case .createName: CreateNameView()
                    }
                }
        }
        .tint(.white)
    }
}
