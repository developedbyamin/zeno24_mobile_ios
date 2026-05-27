import SwiftUI
import UIKit

enum AppColors {
    // MARK: Brand (scheme-agnostic)
    static let brand         = Color(hex: 0x9171F4)
    static let brandDeep     = Color(hex: 0x7A57D8)
    static let mainBlack     = Color(hex: 0x121212)
    static let secondaryBlack = Color(hex: 0x4A4A4F)
    static let mainGray      = Color(hex: 0xF3F4F6)
    static let secondaryGray = Color(hex: 0xF6F7F9)
    static let bodyTextGray  = Color(hex: 0x6B7280)

    // MARK: Auth gradient (top → bottom)
    static let gradientTop    = Color(hex: 0x4958F0)
    static let gradientMid    = Color(hex: 0xA68CF7)
    static let gradientBottom = Color(hex: 0xCC89F7)

    // MARK: Status (scheme-agnostic)
    static let success     = Color(hex: 0x22C55E)
    static let warning     = Color(hex: 0xF59E0B)
    static let destructive = Color(hex: 0xEF4444)
    static let info        = Color(hex: 0x3B82F6)

    // MARK: Glass tokens (used on the gradient — already dark by design)
    static let glassFill      = Color.white.opacity(0.12)
    static let glassStroke    = Color.white.opacity(0.4)
    static let glassHighlight = Color.white.opacity(0.06)

    // MARK: Neutral surfaces & text
    static let surfaceMuted = Color(hex: 0xF2F5F9)   // Soft gray card / badge fill
    static let textMuted    = Color(hex: 0x8B98A8)   // Secondary label colour
    static let warningSoft  = Color(hex: 0xFAB923)   // Used on incorrect-code badge

    // MARK: Legacy aliases (kept until callers migrate to `AppTheme`)
    static let primary     = brand
    static let primaryDark = brandDeep
    static let accent      = brand

    static let bgPrimary     = Color(hex: 0xFFFFFF)
    static let bgSecondary   = Color(hex: 0xF7F8FA)
    static let bgTertiary    = Color(hex: 0xEEF1F4)
    static let labelPrimary   = Color(hex: 0x111111)
    static let labelSecondary = Color(hex: 0x6B7280)
    static let labelTertiary  = Color(hex: 0x9CA3AF)
    static let separator      = Color(hex: 0xE5E7EB)
}

// MARK: - Color helpers

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8)  & 0xFF) / 255
        let b = Double(hex         & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }

    init(light: Color, dark: Color) {
        self = Color(uiColor: UIColor { trait in
            UIColor(trait.userInterfaceStyle == .dark ? dark : light)
        })
    }

    init(lightHex: UInt32, darkHex: UInt32) {
        self.init(light: Color(hex: lightHex), dark: Color(hex: darkHex))
    }
}
