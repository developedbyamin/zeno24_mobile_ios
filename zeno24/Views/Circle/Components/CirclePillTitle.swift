import SwiftUI

/// `"Circle: Family"` attributed title — Flutter `SelectedCirclePill.configure`
/// parity: three styles, single label.
///   • "Circle:" — body.xs SemiBold, textColor
///   • " "       — body.xs Bold, gray 8B98A8
///   • name      — body.xs Bold, textColor
enum CirclePillTitle {
    static func attributed(_ name: String, textColor: Color) -> AttributedString {
        var prefix = AttributedString("Circle:")
        prefix.font = AppTypography.bodyXsSemiBold
        prefix.foregroundColor = textColor

        var spacer = AttributedString(" ")
        spacer.font = AppTypography.bodyXsBold
        spacer.foregroundColor = Color(hex: 0x8B98A8)

        var label = AttributedString(name)
        label.font = AppTypography.bodyXsBold
        label.foregroundColor = textColor

        return prefix + spacer + label
    }
}

/// Applies `matchedGeometryEffect` to the source pill so it morphs into the
/// overlay's selected pill (Flutter `HomeCirclesHeroAnimator` parity).
struct CirclePillHeroModifier: ViewModifier {
    let namespace: Namespace.ID?

    func body(content: Content) -> some View {
        if let namespace {
            content.matchedGeometryEffect(
                id: CirclePillHero.id,
                in: namespace,
                properties: .frame,
                isSource: true
            )
        } else {
            content
        }
    }
}
