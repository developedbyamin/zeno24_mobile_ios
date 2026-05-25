import SwiftUI

struct SignPhoneInput: View {
    @Bindable var store: AuthStore
    @FocusState.Binding var focus: SignFocus?
    @State private var showCountryPicker = false

    var body: some View {
        HStack(spacing: 10) {
            Button {
                showCountryPicker = true
                Haptics.selection()
            } label: {
                HStack(spacing: 8) {
                    Text(store.selectedCountry.flag)
                        .font(.system(size: 22))

                    Text(store.selectedCountry.dialCode)
                        .font(AppTypography.headingXsSemiBold)
                        .foregroundStyle(.white)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)

            Rectangle()
                .fill(Color.white)
                .frame(width: 1, height: 20)

            SignAnimatedPhoneNumber(
                digits: $store.phoneNumber,
                placeholder: PhoneHintsData.getHint(store.selectedCountry.id),
                isoCode: store.selectedCountry.id,
                focus: $focus
            )
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showCountryPicker) {
            DialCodeSheet(selected: $store.selectedCountry) {
                showCountryPicker = false
                store.phoneNumber = ""
                DispatchQueue.main.async { focus = .phone }
            }
        }
    }
}
