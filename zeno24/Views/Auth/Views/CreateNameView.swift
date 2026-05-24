import SwiftUI

/// Step 3 — collect the display name. Figma 1829:2926 / 2796:2552.
/// Three vertical sections (header / input / button) with equal flexible
/// space above and below the input, so the field sits centered between
/// the title block and the CTA — matches the Figma `justify-between`.
struct CreateNameView: View {
    @Environment(AuthStore.self) private var store
    @State private var didAppear = false
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        @Bindable var store = store
        AuthScreen {
            VStack(spacing: 0) {
                AuthHeader(isVisible: true, onBack: { store.goBack() }) {
                    AuthAnimatedIcon(source: .asset(AppImages.emojiClappingHands))
                }
                .padding(.top, 16)

                Spacer().frame(height: 20)

                AuthTitle(
                    primary: AppStrings.Auth.CreateName.title,
                    secondary: AppStrings.Auth.CreateName.subtitle,
                    isVisible: true
                )

                Spacer()

                CreateNameInput(store: store, isFocused: $isFieldFocused)

                Spacer()

                AuthCTAButton(
                    title: AppStrings.Common.finish,
                    isEnabled: store.isNameValid,
                    isLoading: store.isSubmitting
                ) {
                    Task { await store.completeProfile() }
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
            try? await Task.sleep(for: .milliseconds(400))
            isFieldFocused = true
        }
        .onChange(of: store.errorMessage) { _, message in
            guard let message else { return }
            OverlayHelper.shared.show(message, kind: .error)
            store.errorMessage = nil
        }
    }
}
