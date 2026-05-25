import SwiftUI

struct KidsCardHeader: View {
    let title: String
    let action: String

    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(AppColors.mainBlack)
            Spacer()
            HStack(spacing: 4) {
                Text(action)
                    .font(AppTypography.bodySmSemiBold)
                    .foregroundStyle(AppColors.brand)
                Image(AppVectors.arrowRight)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(AppColors.brand)
            }
        }
    }
}
