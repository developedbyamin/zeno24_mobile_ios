import SwiftUI

struct CirclePickerStep: View {
    var onClose: () -> Void
    var onCreate: () -> Void
    var onJoin: () -> Void

    @Environment(CirclesStore.self) private var circles
    @Environment(\.openInviteFlow) private var openInviteFlow
    @State private var loadingCircleId: String?

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 8) {
                selectedPill
                CirclesListCard(
                    circles: circles.circles,
                    isLoading: circles.isLoading,
                    selectedCircleId: circles.selectedCircleId,
                    loadingCircleId: loadingCircleId,
                    onRowTap: handleRowTap,
                    onInviteTap: { openInviteFlow($0) }
                )
                actionRow
            }
            .padding(.horizontal, CircleFlowMetrics.contentHorizontalPadding)
            .padding(.top, CircleFlowMetrics.contentTopPadding)

            VStack {
                Spacer(minLength: 0)
                closeButton.padding(.bottom, 36)
            }
        }
    }

    // MARK: - Selected pill

    private var selectedPill: some View {
        HStack(spacing: 0) {
            Image(AppVectors.circleGridInterface)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(AppColors.brand)
                .padding(.trailing, 8)

            Text(CirclePillTitle.attributed(
                circles.selectedCircle?.name ?? "Family",
                textColor: AppColors.mainBlack
            ))

            Spacer()

            if pendingCount > 0 {
                let pendingOrange = Color(hex: 0xFF5F03)
                Text("\(pendingCount) Pending")
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(pendingOrange)
                    .padding(.horizontal, 12)
                    .frame(height: 24)
                    .background(pendingOrange.opacity(0.08), in: Capsule())
            }
        }
        .padding(.horizontal, 16)
        .frame(height: CircleFlowMetrics.headerHeight)
        .background(Color.white, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.white, lineWidth: 1))
    }

    private var pendingCount: Int { 0 }

    // MARK: - Action row

    private var actionRow: some View {
        HStack(spacing: 8) {
            actionButton(title: "Join a circle", style: .secondary, action: onJoin)
            actionButton(title: "Create a Circle", style: .primary, action: onCreate)
        }
    }

    private enum ActionStyle { case primary, secondary }

    private func actionButton(title: String, style: ActionStyle, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.bodyXsBold)
                .foregroundStyle(style == .primary ? .white : AppColors.brand)
                .frame(maxWidth: .infinity)
                .frame(height: CircleFlowMetrics.headerHeight)
                .background(style == .primary ? AppColors.brand : Color.white, in: Capsule())
        }
        .buttonStyle(ScalePressStyle())
    }

    // MARK: - Close

    private var closeButton: some View {
        Button(action: onClose) {
            Image(AppVectors.closeSmall)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(AppColors.mainBlack)
                .frame(width: 48, height: 48)
                .background(Color.white, in: Circle())
                .overlay(Circle().strokeBorder(Color.white, lineWidth: 1))
                .shadow(color: AppColors.mainBlack.opacity(0.1), radius: 16, x: 0, y: 16)
                .shadow(color: AppColors.mainBlack.opacity(0.05), radius: 2, x: 0, y: 4)
        }
        .buttonStyle(ScalePressStyle())
    }

    // MARK: - Row tap

    private func handleRowTap(_ circle: CircleModel) {
        guard loadingCircleId == nil else { return }
        withAnimation(.easeInOut(duration: 0.18)) {
            circles.selectedCircleId = circle.id
            loadingCircleId = circle.id
        }
        Task {
            await circles.switchTo(circle.id)
            try? await Task.sleep(for: .milliseconds(450))
            loadingCircleId = nil
            onClose()
        }
    }
}
