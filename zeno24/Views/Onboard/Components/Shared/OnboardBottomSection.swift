import SwiftUI
import AuthenticationServices

struct OnboardBottomSection: View {
    @Bindable var store: AuthStore
    let onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Button {
                Haptics.selection()
                onGetStarted()
            } label: {
                Text(AppStrings.Onboard.useEmailOrWhatsapp)
                    .font(AppTypography.bodySmBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white, in: Capsule())
            }
            .buttonStyle(.plain)

            OnboardDividerWithText(text: AppStrings.Common.or)
                .frame(height: 14)

            HStack(spacing: 8) {
                OnboardSocialButton(provider: .apple) {
                    triggerApple()
                }
                .overlay {
                    // HIG-required native button hidden on top of the glass
                    // pill so the visual stays exactly the Figma design.
                    SignInWithAppleButton(.continue) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        handleApple(result)
                    }
                    .signInWithAppleButtonStyle(.white)
                    .clipShape(Capsule())
                    .opacity(0.001)
                }

                OnboardSocialButton(provider: .google) {
                    Task { await store.signInWithGoogle() }
                }
            }
            .frame(height: 48)

            OnboardTermsText()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Apple

    private func triggerApple() {
    }

    private func handleApple(_ result: Result<ASAuthorization, Error>) {
        guard case .success(let authorization) = result,
              let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityData = credential.identityToken,
              let identityToken = String(data: identityData, encoding: .utf8)
        else { return }

        let name = [credential.fullName?.givenName, credential.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")

        Task {
            await store.signInWithApple(idToken: identityToken,
                                        username: name.isEmpty ? nil : name)
        }
    }
}
