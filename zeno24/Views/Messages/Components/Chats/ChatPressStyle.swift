import SwiftUI

/// Shared press feedback for chat composer buttons (quick-reply chips and
/// the send button). Slight scale + opacity dip so taps feel responsive.
struct ChatPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
