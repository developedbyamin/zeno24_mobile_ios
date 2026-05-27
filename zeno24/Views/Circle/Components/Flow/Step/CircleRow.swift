import SwiftUI

struct CircleRow: View {
    let circle: CircleModel
    let isSelected: Bool
    let isLoadingThis: Bool
    let isBlocked: Bool
    var onTap: () -> Void
    var onInviteTap: () -> Void

    private var displayName: String {
        circle.name.isEmpty ? "My Circle" : circle.name
    }

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                avatarBubble

                VStack(alignment: .leading, spacing: 6) {
                    Text(displayName)
                        .font(AppTypography.bodySmBold)
                        .foregroundStyle(AppColors.mainBlack)
                    Text("\(circle.memberCount) Members")
                        .font(AppTypography.bodyXsMedium)
                        .foregroundStyle(AppColors.textMuted)
                }

                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)

            Button(action: onInviteTap) {
                actionDot
            }
            .buttonStyle(ScalePressStyle(pressedOpacity: 0.6))
            .disabled(isBlocked || isLoadingThis)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background((isSelected || isLoadingThis) ? AppColors.surfaceMuted : Color.clear)
        .overlay(
            RowShimmer()
                .opacity(isLoadingThis ? 1 : 0)
                .allowsHitTesting(false)
        )
        .opacity(isBlocked ? 0.4 : 1)
        .allowsHitTesting(!isBlocked && !isLoadingThis)
    }

    private var avatarBubble: some View {
        ZStack {
            Circle().fill(Color(hex: 0x0088FF))
            Text(String(displayName.prefix(1)).uppercased())
                .font(AppTypography.bodyMdBold)
                .foregroundStyle(.white)
        }
        .frame(width: CircleFlowMetrics.avatarSize, height: CircleFlowMetrics.avatarSize)
    }

    private var actionDot: some View {
        ZStack {
            Circle().fill(isSelected ? AppColors.brand : AppColors.surfaceMuted)
            Image(systemName: "plus")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isSelected ? .white : AppColors.mainBlack)
        }
        .frame(width: 24, height: 24)
    }
}

// MARK: - Loading shimmer

struct RowShimmer: View {
    @State private var animating = false

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let base = AppColors.surfaceMuted
            let highlight = Color.white.opacity(0.9)

            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [base, highlight, base]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: w * 2)
                .offset(x: animating ? w * 0.5 : -w * 1.5)
                .onAppear {
                    withAnimation(
                        .linear(duration: 1.2).repeatForever(autoreverses: false)
                    ) {
                        animating = true
                    }
                }
        }
        .clipped()
        .allowsHitTesting(false)
    }
}
