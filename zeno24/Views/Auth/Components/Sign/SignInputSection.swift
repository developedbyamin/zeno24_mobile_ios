import SwiftUI

struct SignInputSection: View {
    @Bindable var store: AuthStore
    @FocusState.Binding var focus: SignFocus?

    var body: some View {
        Group {
            switch store.contactMode {
            case .phone:
                SignPhoneInput(store: store, focus: $focus)
                    .id(AuthContactMode.phone)
            case .email:
                SignEmailInput(store: store, focus: $focus)
                    .id(AuthContactMode.email)
            }
        }
        .transition(.opacity.combined(with: .offset(y: 6)))
        .animation(.smooth(duration: 0.32), value: store.contactMode)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
}

enum SignFocus: Hashable {
    case phone
    case email
}
