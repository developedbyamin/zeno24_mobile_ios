import SwiftUI

/// The entire pre-auth flow as one `NavigationStack`. Onboarding sits
/// at the root; tapping "Use email or Whatsapp" pushes `SignView`, OTP
/// and create-name screens push on top of that. The OS handles every
/// transition with its native Cupertino slide.
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
