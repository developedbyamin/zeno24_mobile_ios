import SwiftUI

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
