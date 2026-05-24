import SwiftUI

/// Two-line title — Figma node `1829:2781`.
///   Both lines: 20pt SemiBold White, line-height ~normal, center.
struct AuthTitle: View {
    let primary: String
    let secondary: String
    let isVisible: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text(primary)
                .font(AppTypography.headingXsSemiBold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(secondary)
                .font(AppTypography.headingXsSemiBold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .id(secondary)
                .transition(.opacity.combined(with: .offset(y: 6)))
        }
        .animation(.smooth(duration: 0.25), value: secondary)
    }
}
