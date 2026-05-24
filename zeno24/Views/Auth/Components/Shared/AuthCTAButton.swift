import SwiftUI

/// Primary auth CTA — Figma node `4117:6487`.
/// Thin wrapper around `AuthCTAButtonStyle` so the call site can express
/// "Continue" without repeating the pill/loader plumbing.
struct AuthCTAButton: View {
    let title: String
    let isEnabled: Bool
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView().tint(AppColors.brand)
                } else {
                    Text(title)
                }
            }
        }
        .buttonStyle(AuthCTAButtonStyle(isEnabled: isEnabled))
        .disabled(!isEnabled || isLoading)
        .animation(.smooth(duration: 0.2), value: isEnabled)
        .animation(.smooth(duration: 0.2), value: isLoading)
    }
}
