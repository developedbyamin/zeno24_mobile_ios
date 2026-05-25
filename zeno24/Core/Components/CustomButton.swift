import SwiftUI

struct CustomButton: View {
    let title: String
    var icon: String? = nil
    var isLoading: Bool = false
    var isEnabled: Bool = true
    var style: Style = .primary
    let action: () -> Void

    enum Style { case primary, secondary, destructive }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.s) {
                if isLoading {
                    ProgressView().tint(.white)
                } else if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.5)
        .modifier(StyleModifier(style: style))
    }

    private struct StyleModifier: ViewModifier {
        let style: Style

        @ViewBuilder
        func body(content: Content) -> some View {
            switch style {
            case .primary:     content.buttonStyle(PrimaryButtonStyle())
            case .secondary:   content.buttonStyle(SecondaryButtonStyle())
            case .destructive: content.buttonStyle(DestructiveButtonStyle())
            }
        }
    }
}
