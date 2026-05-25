import SwiftUI

// MARK: - Primary (themed surface, brand background)

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.appTheme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.bodyLg.weight(.semibold))
            .foregroundStyle(theme.palette.onBrand)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(theme.palette.brand,
                        in: RoundedRectangle(cornerRadius: theme.radius.large, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Secondary (themed surface, low-contrast)

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.appTheme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.bodyLg.weight(.semibold))
            .foregroundStyle(theme.palette.labelPrimary)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(theme.palette.surface,
                        in: RoundedRectangle(cornerRadius: theme.radius.large, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

// MARK: - Destructive

struct DestructiveButtonStyle: ButtonStyle {
    @Environment(\.appTheme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.bodyLg.weight(.semibold))
            .foregroundStyle(theme.palette.onBrand)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(theme.palette.destructive,
                        in: RoundedRectangle(cornerRadius: theme.radius.large, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

// MARK: - Auth CTA (white pill, brand-color label)

struct AuthCTAButtonStyle: ButtonStyle {
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.bodySmBold)
            .foregroundStyle(AppColors.brand.opacity(isEnabled ? 1 : 0.5))
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(Color.white.opacity(isEnabled ? 1 : 0.5), in: Capsule())
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Glass pill (social / mode toggle)

struct GlassPillButtonStyle: ButtonStyle {
    var fillOpacity: Double = 0.24
    var borderOpacity: Double = 0.0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.white.opacity(fillOpacity), in: Capsule())
            .overlay {
                if borderOpacity > 0 {
                    Capsule().strokeBorder(Color.white.opacity(borderOpacity), lineWidth: 1)
                }
            }
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
