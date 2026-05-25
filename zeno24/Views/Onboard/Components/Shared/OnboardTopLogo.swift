import SwiftUI

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
