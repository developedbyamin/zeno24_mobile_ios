import SwiftUI

/// Step 1 of the auth flow — Figma node `1829:2776` / `5376:2602`.
struct SignView: View {
    @Environment(AuthStore.self) private var store
    @State private var didAppear = false
    @FocusState private var focus: SignFocus?

    var body: some View {
        @Bindable var store = store
        AuthScreen {
            VStack(spacing: 0) {
                topSection(store: store)
                    .padding(.top, 16)

                Spacer(minLength: 16)

                middleSection(store: store)

                Spacer(minLength: 16)

                AuthCTAButton(
                    title: AppStrings.Common.continue,
                    isEnabled: store.isContactValid,
                    isLoading: store.isSubmitting
                ) {
                    Task { await store.submitContact() }
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 16)
            .opacity(didAppear ? 1 : 0)
            .offset(y: didAppear ? 0 : 8)
            .animation(.easeOut(duration: 0.28), value: didAppear)
        }
        .task {
            await Task.yield()
            didAppear = true
            try? await Task.sleep(for: .milliseconds(450))
            focus = store.contactMode == .phone ? .phone : .email
        }
        .onChange(of: store.contactMode) { _, mode in
            focus = mode == .phone ? .phone : .email
        }
        .onChange(of: store.errorMessage) { _, message in
            guard let message else { return }
            OverlayHelper.shared.show(message, kind: .error)
            store.errorMessage = nil
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private func topSection(store: AuthStore) -> some View {
        VStack(spacing: 20) {
            AuthHeader(isVisible: true, canGoBack: true, onBack: { store.goBack() }) {
                AuthAnimatedIcon(source: iconSource(for: store.contactMode))
            }
            AuthTitle(
                primary: titlePrimary(for: store.contactMode),
                secondary: titleSecondary,
                isVisible: true
            )
        }
    }

    @ViewBuilder
    private func middleSection(store: AuthStore) -> some View {
        VStack(spacing: 32) {
            SignInputSection(store: store, focus: $focus)
            SignModeToggle(store: store, focus: $focus)
        }
    }

    // MARK: - Copy

    private func iconSource(for mode: AuthContactMode) -> AuthAnimatedIcon.Source {
        switch mode {
        case .phone: return .asset(AppImages.emojiSpeechBubbles)
        case .email: return .asset(AppImages.emojiOpenEnvelope)
        }
    }

    private func titlePrimary(for mode: AuthContactMode) -> String {
        switch mode {
        case .phone: return AppStrings.Auth.SignIn.titlePhone
        case .email: return AppStrings.Auth.SignIn.titleEmail
        }
    }

    private var titleSecondary: String { AppStrings.Auth.SignIn.subtitle }
}
