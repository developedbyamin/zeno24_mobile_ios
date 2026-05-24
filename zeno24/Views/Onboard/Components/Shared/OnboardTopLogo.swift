import SwiftUI

/// Top-centered brand mark. Mirrors the Figma "navimax" placement at
/// `top: 77pt`, 145pt-wide. We render the Zeno24 name in place of the
/// placeholder mark from the design system.
struct OnboardTopLogo: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "location.north.circle.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            Text(AppStrings.Brand.name)
                .font(AppTypography.headingXsBold)
                .foregroundStyle(.white)
        }
    }
}
