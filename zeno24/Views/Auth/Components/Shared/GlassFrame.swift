import SwiftUI

struct GlassFrame<Content: View>: View {
    var cornerRadius: CGFloat = 16
    var fillOpacity: Double = 0.12
    var borderOpacity: Double = 0.4
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .glassSurface(
                cornerRadius: cornerRadius,
                fillOpacity: fillOpacity,
                borderOpacity: borderOpacity
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
