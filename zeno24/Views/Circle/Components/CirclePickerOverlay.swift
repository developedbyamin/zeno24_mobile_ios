import SwiftUI

/// Full-screen circle picker overlay (Figma 5421:8762 Variant2). Lavender
/// gradient blur background, white "Circles" card with rows for each
/// circle (selected row tinted gray `#F2F5F9`), and a circular close button
/// below where the pill would normally sit.
struct CirclePickerOverlay: View {
    let circles: [CircleModel]
    let selectedId: String?
    let onSelect: (String) -> Void
    let onClose: () -> Void

    @Environment(\.openCreateCircle) private var openCreate
    @Environment(\.openJoinCircle) private var openJoin
    @Environment(CirclesStore.self) private var circlesStore
    @State private var didAppear = false
    @State private var loadingCircleId: String?

    var body: some View {
        ZStack {
            background
                .opacity(didAppear ? 1 : 0)
                .onTapGesture { dismiss() }

            VStack(spacing: 0) {
                Spacer(minLength: 0)
                card
                    .padding(.horizontal, 10)
                    .padding(.bottom, 24)
                    .scaleEffect(didAppear ? 1 : 0.94)
                    .opacity(didAppear ? 1 : 0)
                closeButton
                    .padding(.bottom, 14)
                    .opacity(didAppear ? 1 : 0)
                    .scaleEffect(didAppear ? 1 : 0.7)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.22)) {
                didAppear = true
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.18)) {
            didAppear = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            onClose()
        }
    }

    // MARK: - Background

    private var background: some View {
        LavenderBlurBackdrop()
    }

    // MARK: - Card

    private var card: some View {
        // Match the home-top-bar `CirclePickerSheet` cap — past 7 rows the
        // list scrolls internally instead of pushing the close button off
        // the bottom of the screen. Rows are a fixed 64pt with 1pt dividers
        // between non-selected neighbours.
        let rowHeight: CGFloat = 64
        let dividerHeight: CGFloat = 1
        let maxVisible = 7
        let visibleCount = max(1, min(circles.count, maxVisible))
        let listHeight = rowHeight * CGFloat(visibleCount)
            + dividerHeight * CGFloat(max(0, visibleCount - 1))
        let isScrollable = circles.count > maxVisible

        return VStack(alignment: .leading, spacing: 12) {
            Text("Circles")
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(AppColors.mainBlack)
                .padding(.horizontal, 20)

            ScrollView(.vertical, showsIndicators: isScrollable) {
                VStack(spacing: 0) {
                    ForEach(Array(circles.enumerated()), id: \.element.id) { index, circle in
                        row(for: circle)
                        if index < circles.count - 1 {
                            rowDivider
                        }
                    }
                }
            }
            .frame(height: listHeight)
            .scrollDisabled(!isScrollable)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 16)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 4)
    }

    private func row(for circle: CircleModel) -> some View {
        let isLoadingThis = loadingCircleId == circle.id
        let isBlocked = loadingCircleId != nil && !isLoadingThis
        let isHighlighted = circle.id == selectedId || isLoadingThis

        return HStack(spacing: 10) {
            avatar(for: circle)
            VStack(alignment: .leading, spacing: 6) {
                Text(circle.name)
                    .font(.custom("PlusJakartaSans-Bold", size: 14))
                    .foregroundStyle(AppColors.mainBlack)
                Text("\(circle.memberCount) Members")
                    .font(.custom("PlusJakartaSans-Medium", size: 12))
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isHighlighted ? Color(hex: 0xF2F5F9) : Color.clear)
        .overlay(
            CirclePickerShimmer()
                .opacity(isLoadingThis ? 1 : 0)
                .allowsHitTesting(false)
        )
        .opacity(isBlocked ? 0.4 : 1)
        .contentShape(Rectangle())
        .onTapGesture { handleRowTap(circle.id) }
        .allowsHitTesting(loadingCircleId == nil)
    }

    private func handleRowTap(_ id: String) {
        guard loadingCircleId == nil else { return }
        withAnimation(.easeInOut(duration: 0.18)) {
            circlesStore.selectedCircleId = id
            loadingCircleId = id
        }
        Task {
            await circlesStore.switchTo(id)
            try? await Task.sleep(for: .milliseconds(450))
            loadingCircleId = nil
            onSelect(id)
            dismiss()
        }
    }

    private func avatar(for circle: CircleModel) -> some View {
        ZStack {
            Circle().fill(Color(hex: 0x0F85EB))
            Text(String(circle.name.prefix(1)).uppercased())
                .font(AppTypography.bodyMdBold)
                .foregroundStyle(.white)
        }
        .frame(width: 48, height: 48)
    }

    private var rowDivider: some View {
        HStack {
            Spacer()
            Color(hex: 0xF2F5F9).frame(height: 1)
        }
        .frame(width: 276, height: 1)
    }

    // MARK: - Close button

    private var closeButton: some View {
        Image(systemName: "xmark")
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(AppColors.mainBlack)
            .frame(width: 48, height: 48)
            .background(Color.white, in: Circle())
            .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: 16)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 4)
            .contentShape(Circle())
            .onTapGesture { dismiss() }
    }
}

/// Soft, transparent highlight that gently sweeps across the selected row
/// without obscuring its content. The gradient is fully transparent on both
/// sides and only ~25% white in the middle, so the avatar and labels remain
/// fully readable while a subtle gloss travels left → right.
private struct CirclePickerShimmer: View {
    @State private var animating = false

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let bandWidth = w * 0.6

            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white.opacity(0), location: 0.0),
                    .init(color: Color.white.opacity(0.22), location: 0.5),
                    .init(color: Color.white.opacity(0), location: 1.0),
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: bandWidth)
            .offset(x: animating ? w : -bandWidth)
            .animation(
                .easeInOut(duration: 1.1).repeatForever(autoreverses: false),
                value: animating
            )
            .onAppear { animating = true }
        }
        .clipped()
        .blendMode(.plusLighter)
        .allowsHitTesting(false)
    }
}
