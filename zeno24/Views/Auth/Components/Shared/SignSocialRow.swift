import SwiftUI
import AuthenticationServices

/// "Continue with Apple / Google" row used under the contact input.
/// Apple is native via SignInWithAppleButton; Google is a glass button
/// that delegates back to the store.
struct SignSocialRow: View {
    @Bindable var store: AuthStore

    var body: some View {
        VStack(spacing: AppSpacing.m) {
            HStack(spacing: AppSpacing.s) {
                Rectangle()
                    .fill(AppColors.glassStroke)
                    .frame(height: 1)
                Text(AppStrings.Common.or)
                    .font(AppTypography.bodyXsRegular)
                    .foregroundStyle(.white.opacity(0.6))
                Rectangle()
                    .fill(AppColors.glassStroke)
                    .frame(height: 1)
            }

            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                handleApple(result)
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 52)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusLarge, style: .continuous))

            Button {
                Task { await store.signInWithGoogle() }
            } label: {
                HStack(spacing: AppSpacing.s) {
                    Image(systemName: "g.circle.fill")
                        .font(.system(size: 18))
                    Text(AppStrings.Auth.Social.continueWithGoogle)
                        .font(AppTypography.bodyLgSemiBold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(AppColors.glassFill, in: RoundedRectangle(cornerRadius: AppSpacing.radiusLarge, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AppSpacing.radiusLarge, style: .continuous)
                        .strokeBorder(AppColors.glassStroke, lineWidth: 1)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, AppSpacing.l)
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
