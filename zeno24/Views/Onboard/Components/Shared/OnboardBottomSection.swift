import SwiftUI

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
                // Figma's glass pill style — Apple HIG allows custom buttons
                // as long as they're prominent and use the Apple logo; we
                // trigger ASAuthorizationController directly so the visible
                // button can be our SwiftUI control.
                OnboardSocialButton(
                    provider: .apple,
                    isLoading: store.isAppleSubmitting
                ) {
                    Task { await store.signInWithApple() }
                }

                OnboardSocialButton(
                    provider: .google,
                    isLoading: store.isGoogleSubmitting
                ) {
                    Task { await store.signInWithGoogle() }
                }
            }
            .frame(height: 48)

            OnboardTermsText()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}
