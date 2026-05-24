import SwiftUI

/// Type ramp — 1:1 mirror of `lib/core/config/theme/text_theme.dart`.
///
/// Usage:
///   Text("Hello").font(AppTypography.bodyMdSemiBold)
///
/// Sizes: Heading 2Xl=32 / Md=28 / Sm=24 / Xs=20
///        Body    Lg=18 / Md=16 / Sm=14 / Xs=12 / 2Xs=10
/// Weights: Regular(400) · Medium(500) · SemiBold(600) · Bold(700)
///
/// We use **four static `Plus Jakarta Sans` faces** (Regular/Medium/SemiBold/Bold)
/// because SwiftUI's `Font.custom(...).weight(.bold)` does NOT drive the
/// variable-axis `wght` value — Core Text loads only the font's default
/// PostScript face. Each weight ships as its own `.ttf` and is referenced
/// by exact PostScript name.
enum AppTypography {

    // MARK: - Internal helpers

    private enum PJS {
        static let regular  = "PlusJakartaSans-Regular"
        static let medium   = "PlusJakartaSans-Medium"
        static let semibold = "PlusJakartaSans-SemiBold"
        static let bold     = "PlusJakartaSans-Bold"
    }

    private static func regular(_ size: CGFloat)  -> Font { .custom(PJS.regular,  size: size) }
    private static func medium(_ size: CGFloat)   -> Font { .custom(PJS.medium,   size: size) }
    private static func semibold(_ size: CGFloat) -> Font { .custom(PJS.semibold, size: size) }
    private static func bold(_ size: CGFloat)     -> Font { .custom(PJS.bold,     size: size) }

    // ============================================
    // HEADING — 32 / 28 / 24 / 20
    // ============================================

    // 2XL = 32
    static let heading2XlRegular  = regular(32)
    static let heading2XlMedium   = medium(32)
    static let heading2XlSemiBold = semibold(32)
    static let heading2XlBold     = bold(32)

    // MD = 28
    static let headingMdRegular   = regular(28)
    static let headingMdMedium    = medium(28)
    static let headingMdSemiBold  = semibold(28)
    static let headingMdBold      = bold(28)

    // SM = 24
    static let headingSmRegular   = regular(24)
    static let headingSmMedium    = medium(24)
    static let headingSmSemiBold  = semibold(24)
    static let headingSmBold      = bold(24)

    // XS = 20
    static let headingXsRegular   = regular(20)
    static let headingXsMedium    = medium(20)
    static let headingXsSemiBold  = semibold(20)
    static let headingXsBold      = bold(20)

    // ============================================
    // BODY — 18 / 16 / 14 / 12 / 10
    // ============================================

    // LG = 18
    static let bodyLgRegular      = regular(18)
    static let bodyLgMedium       = medium(18)
    static let bodyLgSemiBold     = semibold(18)
    static let bodyLgBold         = bold(18)

    // MD = 16
    static let bodyMdRegular      = regular(16)
    static let bodyMdMedium       = medium(16)
    static let bodyMdSemiBold     = semibold(16)
    static let bodyMdBold         = bold(16)

    // SM = 14
    static let bodySmRegular      = regular(14)
    static let bodySmMedium       = medium(14)
    static let bodySmSemiBold     = semibold(14)
    static let bodySmBold         = bold(14)

    // XS = 12
    static let bodyXsRegular      = regular(12)
    static let bodyXsMedium       = medium(12)
    static let bodyXsSemiBold     = semibold(12)
    static let bodyXsBold         = bold(12)

    // 2XS = 10
    static let body2XsRegular     = regular(10)
    static let body2XsMedium      = medium(10)
    static let body2XsSemiBold    = semibold(10)
    static let body2XsBold        = bold(10)
}
