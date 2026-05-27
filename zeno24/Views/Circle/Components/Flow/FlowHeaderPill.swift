import SwiftUI

struct FlowHeaderPill: View {
    let title: String
    var leadingIcon: String? = nil
    var disabled: Bool = false
    var onBack: () -> Void

    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                if let leadingIcon {
                    Image(leadingIcon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(AppColors.brand)
                }
                Text(title)
                    .font(AppTypography.bodySmSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
            }
            HStack {
                Button(action: onBack) {
                    Image(AppVectors.backArrow)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: CircleFlowMetrics.headerBackIconSize,
                            height: CircleFlowMetrics.headerBackIconSize
                        )
                        .foregroundStyle(AppColors.mainBlack)
                        .frame(
                            width: CircleFlowMetrics.headerBackButtonSize,
                            height: CircleFlowMetrics.headerBackButtonSize
                        )
                        .background(AppColors.surfaceMuted, in: Circle())
                }
                .buttonStyle(ScalePressStyle())
                .disabled(disabled)
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: CircleFlowMetrics.headerHeight)
        .background(Color.white, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.white, lineWidth: 1))
    }
}
