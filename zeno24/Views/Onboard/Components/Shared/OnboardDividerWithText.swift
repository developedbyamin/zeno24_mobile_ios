import SwiftUI

/// Horizontal rule split by centered text. Figma node `4140:7055`:
///   line color = white/30, height 1, gap 8, text 12pt Medium white.
struct OnboardDividerWithText: View {
    let text: String

    var body: some View {
        HStack(spacing: AppSpacing.s) {
            line
            Text(text)
                .font(AppTypography.bodyXsMedium)
                .foregroundStyle(.white)
                .fixedSize()
            line
        }
    }

    private var line: some View {
        Rectangle()
            .fill(Color.white.opacity(0.3))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}
