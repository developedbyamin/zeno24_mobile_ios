import SwiftUI

/// Field + shake-on-error wrapper. The shake animates the offset while
/// `triggerShake` flips — same idea as Flutter's `AnimationController.forward(from: 0)`.
struct OtpInputSection: View {
    @Bindable var store: AuthStore
    @FocusState.Binding var focus: Bool
    var onComplete: () -> Void

    @State private var shakeOffset: CGFloat = 0
    @State private var lastErrorState: Bool = false

    var body: some View {
        OtpDigitField(
            code: $store.otpCode,
            length: 6,
            hasError: store.showOtpError,
            isFocused: $focus,
            onComplete: onComplete
        )
        .padding(.horizontal, AppSpacing.l)
        .offset(x: shakeOffset)
        .onChange(of: store.showOtpError) { _, isError in
            guard isError, !lastErrorState else { lastErrorState = isError; return }
            lastErrorState = isError
            performShake()
        }
        .onChange(of: store.otpCode) { _, _ in
            // Typing again clears the error.
            store.clearOtpError()
        }
    }

    private func performShake() {
        let pattern: [(CGFloat, Double)] = [
            (-10, 0.06), (10, 0.06), (-8, 0.06),
            (8, 0.06),   (-4, 0.06), (0, 0.06)
        ]
        Task {
            for (offset, duration) in pattern {
                withAnimation(.easeInOut(duration: duration)) { shakeOffset = offset }
                try? await Task.sleep(for: .seconds(duration))
            }
        }
    }
}
