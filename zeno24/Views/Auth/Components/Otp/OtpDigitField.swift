import SwiftUI

/// 6-cell OTP field — Figma 3987:6184 / 2797:15244.
///   • Each slot shows the entered digit, blinking caret, or a faded "-".
///   • Slots share a 1-pt underline (no surrounding box).
///   • Hidden TextField gives us iOS SMS AutoFill above the keyboard.
struct OtpDigitField: View {
    @Binding var code: String
    let length: Int
    var hasError: Bool = false
    @FocusState.Binding var isFocused: Bool
    var onComplete: () -> Void = {}

    var body: some View {
        ZStack {
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0.001)
                .frame(height: 1)
                .onChange(of: code) { _, new in
                    let digits = new.filter(\.isNumber)
                    if digits.count > length { code = String(digits.prefix(length)) }
                    else if digits != new   { code = digits }
                    if code.count == length { onComplete() }
                }

            HStack(spacing: 24) {
                ForEach(0..<length, id: \.self) { index in
                    OtpDigitSlot(
                        character: character(at: index),
                        isActive: index == code.count && isFocused,
                        hasError: hasError
                    )
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
        }
    }

    private func character(at index: Int) -> String? {
        guard index < code.count else { return nil }
        return String(code[code.index(code.startIndex, offsetBy: index)])
    }
}

// MARK: - Slot

private struct OtpDigitSlot: View {
    let character: String?
    let isActive: Bool
    let hasError: Bool

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                if let character {
                    Text(character)
                        .font(AppTypography.headingMdBold)
                        .foregroundStyle(.white)
                        .transition(.scale.combined(with: .opacity))
                } else if isActive {
                    Caret()
                } else {
                    Text("-")
                        .font(AppTypography.headingMdBold)
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
            .frame(height: 36)
            .animation(.smooth(duration: 0.18), value: character)
            .animation(.smooth(duration: 0.18), value: isActive)

            Rectangle()
                .fill(underlineColor)
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity)
    }

    private var underlineColor: Color {
        if hasError              { return AppColors.destructive }
        if character != nil      { return .white }
        if isActive              { return .white }
        return Color.white.opacity(0.3)
    }
}

// MARK: - Caret

private struct Caret: View {
    @State private var visible = true

    var body: some View {
        Rectangle()
            .fill(.white)
            .frame(width: 2, height: 28)
            .opacity(visible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    visible = false
                }
            }
    }
}
