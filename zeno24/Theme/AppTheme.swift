import SwiftUI

struct AppTheme {
    var palette: Palette
    var typography: Typography
    var radius: Radius
    var spacing: Spacing

    static let `default` = AppTheme(
        palette: .default,
        typography: .default,
        radius: .default,
        spacing: .default
    )
}

// MARK: - Palette

extension AppTheme {
    struct Palette {
        var brand: Color
        var brandDeep: Color
        var onBrand: Color

        var background: Color
        var surface: Color
        var surfaceElevated: Color

        var labelPrimary: Color
        var labelSecondary: Color
        var labelTertiary: Color

        var separator: Color
        var border: Color

        var success: Color
        var warning: Color
        var destructive: Color
        var info: Color

        static let `default` = Palette(
            brand:        AppColors.brand,
            brandDeep:    AppColors.brandDeep,
            onBrand:      .white,

            background:      Color(lightHex: 0xFFFFFF, darkHex: 0x0C0C0F),
            surface:         Color(lightHex: 0xF7F8FA, darkHex: 0x1C1C1E),
            surfaceElevated: Color(lightHex: 0xEEF1F4, darkHex: 0x2C2C2E),

            labelPrimary:   Color(lightHex: 0x111111, darkHex: 0xFFFFFF),
            labelSecondary: Color(lightHex: 0x6B7280, darkHex: 0xA0A0AB),
            labelTertiary:  Color(lightHex: 0x9CA3AF, darkHex: 0x6B7280),

            separator: Color(lightHex: 0xE5E7EB, darkHex: 0x38383A),
            border:    Color(lightHex: 0xD1D5DB, darkHex: 0x48484A),

            success:     AppColors.success,
            warning:     AppColors.warning,
            destructive: AppColors.destructive,
            info:        AppColors.info
        )
    }
}

// MARK: - Typography

extension AppTheme {
    struct Typography {
        var bodySm: Font
        var bodyMd: Font
        var bodyLg: Font
        var bodySmBold: Font
        var bodyMdSemiBold: Font
        var headingXsSemiBold: Font
        var headingXsBold: Font
        var headingMdBold: Font
        var heading2XlBold: Font

        static let `default` = Typography(
            bodySm:            AppTypography.bodySmRegular,
            bodyMd:            AppTypography.bodyMdRegular,
            bodyLg:            AppTypography.bodyLgRegular,
            bodySmBold:        AppTypography.bodySmBold,
            bodyMdSemiBold:    AppTypography.bodyMdSemiBold,
            headingXsSemiBold: AppTypography.headingXsSemiBold,
            headingXsBold:     AppTypography.headingXsBold,
            headingMdBold:     AppTypography.headingMdBold,
            heading2XlBold:    AppTypography.heading2XlBold
        )
    }
}

// MARK: - Radius

extension AppTheme {
    struct Radius {
        var small:  CGFloat
        var medium: CGFloat
        var large:  CGFloat
        var pill:   CGFloat

        static let `default` = Radius(small: 10, medium: 14, large: 16, pill: 50)
    }
}

// MARK: - Spacing

extension AppTheme {
    struct Spacing {
        var xs: CGFloat
        var s:  CGFloat
        var m:  CGFloat
        var l:  CGFloat
        var xl: CGFloat
        var xxl: CGFloat

        static let `default` = Spacing(xs: 4, s: 8, m: 12, l: 16, xl: 20, xxl: 24)
    }
}

// MARK: - Environment plumbing

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .default
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}
