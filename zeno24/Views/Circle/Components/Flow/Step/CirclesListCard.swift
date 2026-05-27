import SwiftUI

struct CirclesListCard: View {
    let circles: [CircleModel]
    let isLoading: Bool
    let selectedCircleId: String?
    let loadingCircleId: String?
    var onRowTap: (CircleModel) -> Void
    var onInviteTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Circles")
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(AppColors.mainBlack)
                .padding(.horizontal, 20)

            if isLoading && circles.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            } else {
                rowList
            }
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var rowList: some View {
        let visibleCount = max(1, min(circles.count, CircleFlowMetrics.maxVisibleRows))
        let height = CircleFlowMetrics.rowHeight * CGFloat(visibleCount)
            + CircleFlowMetrics.rowDividerHeight * CGFloat(max(0, visibleCount - 1))
        let isScrollable = circles.count > CircleFlowMetrics.maxVisibleRows

        return ScrollView(.vertical, showsIndicators: isScrollable) {
            VStack(spacing: 0) {
                ForEach(Array(circles.enumerated()), id: \.element.id) { idx, circle in
                    CircleRow(
                        circle: circle,
                        isSelected: isSelected(circle),
                        isLoadingThis: loadingCircleId == circle.id,
                        isBlocked: loadingCircleId != nil && loadingCircleId != circle.id,
                        onTap: { onRowTap(circle) },
                        onInviteTap: { onInviteTap(circle.id) }
                    )
                    if idx < circles.count - 1,
                       !isSelected(circle),
                       !isSelected(circles[idx + 1]) {
                        rowDivider
                    }
                }
            }
        }
        .frame(height: height)
        .scrollDisabled(!isScrollable)
    }

    private var rowDivider: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            AppColors.surfaceMuted.frame(width: 276, height: CircleFlowMetrics.rowDividerHeight)
        }
    }

    private func isSelected(_ circle: CircleModel) -> Bool {
        if let selectedCircleId { return circle.id == selectedCircleId }
        return circles.first?.id == circle.id
    }
}
