import SwiftUI

/// Press feedback for the Messages list rows — dims the row to 60% while
/// the finger is down, fades back in over 120ms.
struct MessageRowPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
