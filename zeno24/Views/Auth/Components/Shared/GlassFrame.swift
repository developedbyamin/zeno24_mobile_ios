import SwiftUI

/// Thin convenience wrapper around `glassSurface()` so call sites can
/// continue using `GlassFrame { … }` semantically. The actual styling
/// lives in `Theme/CardStyles.swift`.
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
