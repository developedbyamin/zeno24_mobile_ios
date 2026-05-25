import SwiftUI

struct CreateNameView: View {
    @Environment(AuthStore.self) private var store
    @State private var vm = CreateNameViewModel()
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
            .opacity(vm.didAppear ? 1 : 0)
            .offset(y: vm.didAppear ? 0 : 8)
            .animation(.easeOut(duration: 0.28), value: vm.didAppear)
        }
        .task {
            await vm.onAppear()
            isFieldFocused = true
        }
        .onChange(of: store.errorMessage) { _, message in
            guard let message else { return }
            OverlayHelper.shared.show(message, kind: .error)
            store.errorMessage = nil
        }
    }
}
