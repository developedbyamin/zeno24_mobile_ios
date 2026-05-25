import SwiftUI

// MARK: - Glass surface (auth icon holder, back button, mode toggle)

struct GlassSurface: ViewModifier {
    var cornerRadius: CGFloat = 16
    var fillOpacity: Double = 0.12
    var borderOpacity: Double = 0.4

    func body(content: Content) -> some View {
        content
            .background(
                Color.white.opacity(fillOpacity),
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(borderOpacity), lineWidth: 1)
            }
    }
}

extension View {
    func glassSurface(cornerRadius: CGFloat = 16,
                      fillOpacity: Double = 0.12,
                      borderOpacity: Double = 0.4) -> some View {
        modifier(GlassSurface(cornerRadius: cornerRadius,
                              fillOpacity: fillOpacity,
                              borderOpacity: borderOpacity))
    }
}

// MARK: - Themed surface card (scheme-aware)

struct ThemedCard: ViewModifier {
    @Environment(\.appTheme) private var theme
    var cornerRadius: CGFloat?

    func body(content: Content) -> some View {
        content
            .background(
                theme.palette.surface,
                in: RoundedRectangle(cornerRadius: cornerRadius ?? theme.radius.large,
                                     style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius ?? theme.radius.large,
                                 style: .continuous)
                    .strokeBorder(theme.palette.separator, lineWidth: 1)
            }
    }
}

extension View {
    func themedCard(cornerRadius: CGFloat? = nil) -> some View {
        modifier(ThemedCard(cornerRadius: cornerRadius))
    }
}
