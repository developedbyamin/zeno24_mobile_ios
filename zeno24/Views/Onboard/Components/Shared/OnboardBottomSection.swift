import SwiftUI
import AuthenticationServices

/// Bottom CTA block — Figma node `3682:6021` at 343 × 198.
///
/// Vertical rhythm (all 16pt gaps):
///   y=0   → CTA (343 × 52)
///   y=68  → Divider (343 × 14)
///   y=98  → Social row (343 × 48)
///   y=162 → Terms (343 × 36)
///
/// Total = 52 + 16 + 14 + 16 + 48 + 16 + 36 = 198 ✓
struct OnboardBottomSection: View {
    @Bindable var store: AuthStore
    let onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // CTA — Figma 343 × 52, label 14pt Bold #121212.
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

            // Divider — Figma 343 × 14.
            OnboardDividerWithText(text: AppStrings.Common.or)
                .frame(height: 14)

            // Social row — Figma 343 × 48, 8pt gap.
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

            // Terms — Figma 343 × 36 (two lines, 12pt).
            OnboardTermsText()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Apple

    private func triggerApple() {
        // No-op — overlay-d SignInWithAppleButton handles the real tap.
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
