import SwiftUI

/// Auth flow's "or continue with..." row. Buttons just call into `AuthStore`
/// — all native (Apple `ASAuthorizationController`, Google `GIDSignIn`) and
/// Firebase exchange plumbing lives in `AuthService`, so this view stays
/// pure SwiftUI.
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

            Button {
                Task { await store.signInWithApple() }
            } label: {
                ZStack {
                    HStack(spacing: AppSpacing.s) {
                        Image(systemName: "applelogo")
                            .font(.system(size: 18, weight: .semibold))
                        Text(AppStrings.Auth.Social.continueWithApple)
                            .font(AppTypography.bodyLgSemiBold)
                    }
                    .opacity(store.isAppleSubmitting ? 0 : 1)

                    if store.isAppleSubmitting {
                        ProgressView().tint(.black)
                    }
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.white, in: RoundedRectangle(cornerRadius: AppSpacing.radiusLarge, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(store.isAppleSubmitting)

            Button {
                Task { await store.signInWithGoogle() }
            } label: {
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
}
