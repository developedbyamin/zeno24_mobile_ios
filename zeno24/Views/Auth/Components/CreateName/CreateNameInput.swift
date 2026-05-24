import SwiftUI

/// Display-name field — Figma 1829:2926 / 2796:2552.
/// • Empty: "Enter your name" placeholder — Plus Jakarta Sans Medium 20, white 40%.
/// • Typed: user input — Plus Jakarta Sans Bold 28, white.
struct CreateNameInput: View {
    @Bindable var store: AuthStore
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        TextField("", text: $store.displayName)
            .textContentType(.name)
            .textInputAutocapitalization(.words)
            .multilineTextAlignment(.center)
            .focused($isFocused)
            .font(AppTypography.headingMdBold)
            .foregroundStyle(.white)
            .tint(.white)
            .autocorrectionDisabled()
            .overlay(alignment: .center) {
                if store.displayName.isEmpty {
                    Text(AppStrings.Auth.CreateName.placeholder)
                        .font(AppTypography.headingXsMedium)
                        .foregroundStyle(Color.white.opacity(0.4))
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 16)
    }
}
