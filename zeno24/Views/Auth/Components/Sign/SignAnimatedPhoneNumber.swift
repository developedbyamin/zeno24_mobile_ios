import SwiftUI

/// Phone digits field — Figma node `1829:2789`.
///
/// The TextField shows the **formatted** number (country-aware spacing
/// like Flutter's `_PhoneInputFormatter`), while `digits` stays raw so
/// the auth flow can send a clean E.164 payload.
struct SignAnimatedPhoneNumber: View {
    @Binding var digits: String
    let placeholder: String
    let isoCode: String
    @FocusState.Binding var focus: SignFocus?

    @State private var display: String = ""

    var body: some View {
        TextField("", text: $display)
            .keyboardType(.numberPad)
            .textContentType(.telephoneNumber)
            .focused($focus, equals: .phone)
            .authTextField()
            .authPlaceholder(placeholder, when: digits.isEmpty, alignment: .leading)
            .fixedSize()
            .onAppear { syncFromDigits() }
            .onChange(of: display) { _, new in
                let raw = PhoneFormattingUtils.sanitize(new)
                let capped = String(raw.prefix(PhoneFormattingUtils.maxLength(isoCode: isoCode)))
                if digits != capped { digits = capped }
                let formatted = PhoneFormattingUtils.format(capped, isoCode: isoCode)
                if display != formatted { display = formatted }
            }
            .onChange(of: digits) { _, _ in syncFromDigits() }
            .onChange(of: isoCode) { _, _ in syncFromDigits() }
    }

    private func syncFromDigits() {
        let formatted = PhoneFormattingUtils.format(digits, isoCode: isoCode)
        if display != formatted { display = formatted }
    }
}
