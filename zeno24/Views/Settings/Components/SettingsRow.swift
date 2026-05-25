import SwiftUI

struct SettingsRow: View {
    let asset: String
    let title: String
    let tint: Color
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                HStack(spacing: 10) {
                    Image(asset)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(tint)
                        .frame(width: 40, height: 40)
                        .background(Color(hex: 0xF8F7FF), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    Text(title)
                        .font(AppTypography.bodySmSemiBold)
                        .foregroundStyle(AppColors.mainBlack)
                }
                Spacer()
                Image(AppVectors.arrowRight)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(AppColors.mainBlack)
            }
        }
        .buttonStyle(.plain)
    }
}
