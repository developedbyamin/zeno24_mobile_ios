import SwiftUI
import AuthenticationServices

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
                SocialSignInLauncher.prepareAppleRequest(request)
            } onCompletion: { result in
                SocialSignInLauncher.handleApple(result: result, into: store)
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 52)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.radiusLarge, style: .continuous))

            Button(action: handleGoogle) {
                ZStack {
                    HStack(spacing: AppSpacing.s) {
                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 18))
                        Text(AppStrings.Auth.Social.continueWithGoogle)
                            .font(AppTypography.bodyLgSemiBold)
                    }
                    .opacity(store.isGoogleSubmitting ? 0 : 1)

                    if store.isGoogleSubmitting {
                        ProgressView().tint(.white)
                    }
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
            .disabled(store.isGoogleSubmitting)
        }
        .padding(.horizontal, AppSpacing.l)
    }

    private func handleGoogle() {
        SocialSignInLauncher.launchGoogle(into: store)
    }
}
