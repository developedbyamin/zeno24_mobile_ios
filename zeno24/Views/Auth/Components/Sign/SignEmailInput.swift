import SwiftUI

/// Borderless email field — Figma node `5376:2602`.
struct SignEmailInput: View {
    @Bindable var store: AuthStore
    @FocusState.Binding var focus: SignFocus?

    var body: some View {
        TextField("", text: $store.email)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .multilineTextAlignment(.center)
            .focused($focus, equals: .email)
            .authTextField()
            .authPlaceholder("example@mail.com", when: store.email.isEmpty)
            .frame(maxWidth: .infinity)
    }
}
