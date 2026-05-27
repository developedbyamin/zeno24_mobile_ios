import SwiftUI

struct ScalePressStyle: ButtonStyle {
    var pressedOpacity: Double = 0.7

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? pressedOpacity : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
