import SwiftUI

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
