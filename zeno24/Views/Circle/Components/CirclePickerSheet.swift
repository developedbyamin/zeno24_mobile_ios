import SwiftUI

/// Full-screen circle picker overlay — 1:1 SwiftUI port of the Flutter
/// project's UIKit `HomeCirclesOverlay`.
///
/// Behaviour parity:
///   • Hero transition: source pill morphs into the white selected pill at
///     the top of the panel (`matchedGeometryEffect`).
///   • Full-screen panel covering tab bar; bottom-only 30 pt corner radius
///     so the panel itself looks like it slides down from the top.
///   • Backdrop = `ultraThinMaterial` (α 0.7) under a purple→pink gradient
///     (each stop α 0.7). Home/Map shows through.
///   • Empty-area taps dismiss; interactive subviews consume their own.
///   • Selected pill: brand-purple icon + attributed
///     "Circle:" + " " + name + "X Pending" orange chip on the right.
///   • Circles list card: 7 visible rows max, then scrollable; selected row
///     uses F2F5F9 background, dividers only between two unselected rows.
///   • Action row: "Join a circle" (white) + "Create a Circle" (brand).
///   • Floating close button — white 48 pt circle, positioned 36 pt above
///     the device's safe-area bottom.
struct CirclePickerSheet: View {
    @Binding var isPresented: Bool
    let namespace: Namespace.ID

    @Environment(CirclesStore.self) private var circles
    @Environment(\.openCreateCircle) private var openCreate
    @Environment(\.openInviteFlow) private var openInviteFlow
    @State private var loadingCircleId: String?

    var body: some View {
        ZStack(alignment: .top) {
            // 1. Background — full-screen, bottom-only 30pt radius. Tap = dismiss.
            backgroundShape
                .ignoresSafeArea()
                .contentShape(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
                        style: .continuous
                    )
                )
                .onTapGesture { dismiss() }
                // Refetch the list every time the sheet opens so it reflects
                // any newly joined / created / removed circles from other
                // surfaces. The store de-dupes concurrent loads internally.
                .task { await circles.load() }

            // 2. Stacked content — sits inside the device safe area (top).
            VStack(spacing: 8) {
                selectedPill
                circlesCard
                actionRow
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)

            // 3. Floating close — anchored to the bottom of the safe area.
            VStack {
                Spacer(minLength: 0)
                closeButton
                    .padding(.bottom, 36)
            }
        }
    }

    // MARK: - Background

    private var backgroundShape: some View {
        UnevenRoundedRectangle(
            cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
            style: .continuous
        )
        .fill(.ultraThinMaterial)
        .opacity(0.7)
        .overlay(
            UnevenRoundedRectangle(
                cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
                style: .continuous
            )
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0xF9/255, green: 0xF1/255, blue: 0xFB/255).opacity(0.7),
                        Color(red: 0xCF/255, green: 0xBD/255, blue: 0xD3/255).opacity(0.7),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        )
    }

    // MARK: - Selected pill (hero destination)

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
                Button {
                    // TODO: open pending invites flow
                } label: {
                    Text("\(pendingCount) Pending")
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(Color(hex: 0xFF5F03))
                        .padding(.horizontal, 12)
                        .frame(height: 24)
                        .background(Color(hex: 0xFF5F03).opacity(0.08), in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(Color.white, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.white, lineWidth: 1))
        .matchedGeometryEffect(
            id: CirclePillHero.id,
            in: namespace,
            properties: .frame,
            isSource: true
        )
        .contentShape(Capsule())
        .onTapGesture { /* consume — don't dismiss */ }
    }

    private var pendingCount: Int {
        // TODO: pull from backend once available.
        0
    }

    // MARK: - Circles list card

    private var circlesCard: some View {
        // Figma 4991:17003 — outer py-16, inner gap-12 between header and rows.
        VStack(alignment: .leading, spacing: 12) {
            Text("Circles")
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(AppColors.mainBlack)
                .padding(.horizontal, 20)

            if circles.isLoading && circles.circles.isEmpty {
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
        .contentShape(Rectangle())
        .onTapGesture { /* consume */ }
    }

    private var rowList: some View {
        let rows = circles.circles
        let rowHeight: CGFloat = 64
        let dividerHeight: CGFloat = 1
        let maxVisible = 7
        let visibleCount = max(1, min(rows.count, maxVisible))
        // Reserve a divider slot per gap between visible rows so the last
        // circle never gets clipped by the scrollView's fixed frame.
        let height = rowHeight * CGFloat(visibleCount)
            + dividerHeight * CGFloat(max(0, visibleCount - 1))
        let isScrollable = rows.count > maxVisible

        return ScrollView(.vertical, showsIndicators: isScrollable) {
            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.element.id) { idx, circle in
                    circleRow(circle)
                    if idx < rows.count - 1,
                       !isSelected(circle),
                       !isSelected(rows[idx + 1]) {
                        rowDivider
                    }
                }
            }
        }
        .frame(height: height)
        .scrollDisabled(!isScrollable)
    }

    private var rowDivider: some View {
        // Figma 4991:17027 — flex-col items-end, h-px w-[276px] (right-aligned
        // 276 pt line that starts after the avatar).
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            Color(hex: 0xF2F5F9)
                .frame(width: 276, height: 1)
        }
    }

    private func isSelected(_ circle: CircleModel) -> Bool {
        if let sel = circles.selectedCircleId { return circle.id == sel }
        return circles.circles.first?.id == circle.id
    }

    private func circleRow(_ circle: CircleModel) -> some View {
        let selected = isSelected(circle)
        let displayName = circle.name.isEmpty ? "My Circle" : circle.name
        let isLoadingThis = loadingCircleId == circle.id
        let isBlocked = loadingCircleId != nil && !isLoadingThis

        // Figma 4991:17009 row spec: px-[20px], py-[8px], gap-[10px].
        // 48 pt avatar + 8+8 vertical padding = 64 pt natural height — never
        // depends on selection state so the row never resizes when picked.
        return HStack(spacing: 10) {
            avatarBubble(displayName)

            VStack(alignment: .leading, spacing: 6) {
                Text(displayName)
                    .font(AppTypography.bodySmBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text("\(circle.memberCount) Members")
                    .font(AppTypography.bodyXsMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }

            Spacer(minLength: 0)

            // Separate Button — Flutter `CircleRow.actionDot` has its own
            // tap target, independent of the row tap.
            Button {
                handleActionTap(circle)
            } label: {
                actionDot(selected: selected)
            }
            .buttonStyle(RowPressStyle())
            .disabled(loadingCircleId != nil)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        // Static background — only the COLOR is animated, never the layout.
        .background((selected || isLoadingThis) ? Color(hex: 0xF2F5F9) : Color.clear)
        // Always-mounted overlay; opacity fades the shimmer in/out without
        // touching parent layout (which is what made the row resize before).
        .overlay(
            ShimmerOverlay()
                .opacity(isLoadingThis ? 1 : 0)
                .allowsHitTesting(false)
        )
        .opacity(isBlocked ? 0.4 : 1)
        .contentShape(Rectangle())
        .onTapGesture { handleRowTap(circle) }
        .allowsHitTesting(loadingCircleId == nil)
    }

    private func avatarBubble(_ name: String) -> some View {
        ZStack {
            Circle().fill(Color(hex: 0x0088FF))
            Text(String(name.prefix(1)).uppercased())
                .font(AppTypography.bodyMdBold)
                .foregroundStyle(.white)
        }
        .frame(width: 48, height: 48)
    }

    private func actionDot(selected: Bool) -> some View {
        // Figma 4991:17016 — 24 pt circle with a 16 pt plus icon.
        ZStack {
            Circle().fill(selected ? AppColors.brand : Color(hex: 0xF2F5F9))
            Image(systemName: "plus")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(selected ? .white : AppColors.mainBlack)
        }
        .frame(width: 24, height: 24)
    }

    private func handleRowTap(_ circle: CircleModel) {
        guard loadingCircleId == nil else { return }
        // Immediately commit selection so the UI flips before the API call —
        // this is the "smooth" feedback the Flutter overlay gives via shimmer.
        withAnimation(.easeInOut(duration: 0.18)) {
            circles.selectedCircleId = circle.id
            loadingCircleId = circle.id
        }
        Task {
            await circles.switchTo(circle.id)
            // Let the shimmer animate at least one cycle before dismissing.
            try? await Task.sleep(for: .milliseconds(450))
            loadingCircleId = nil
            dismiss()
        }
    }

    private func handleActionTap(_ circle: CircleModel) {
        // Flutter `circlesOverlayDidTapAddRole` — role sheet is presented OVER
        // the still-alive circles overlay; the picker must stay open so the
        // user lands back on it when the invite flow finishes.
        openInviteFlow(circle.id)
    }

    // MARK: - Action row

    private var actionRow: some View {
        HStack(spacing: 8) {
            actionButton(title: "Join a circle", style: .secondary) {
                // TODO: join flow
            }
            actionButton(title: "Create a Circle", style: .primary) {
                // Keep the picker open underneath so the gradient background
                // never blinks during the cross-fade to the create sheet
                // (Flutter `HomeCreateCircleOverlay` parity — it's presented
                // over the still-alive circles overlay).
                openCreate()
            }
        }
    }

    private enum ActionStyle { case primary, secondary }

    private func actionButton(title: String, style: ActionStyle, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.bodyXsBold)
                .foregroundStyle(style == .primary ? .white : AppColors.brand)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(style == .primary ? AppColors.brand : Color.white, in: Capsule())
        }
        .buttonStyle(OverlayCapsuleButtonStyle())
    }

    // MARK: - Close

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            // Figma 4991:17043 — 48 pt white capsule, 20 pt "Close remove"
            // glyph, double Drop Shadow/400.
            Image(AppVectors.closeSmall)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(AppColors.mainBlack)
                .frame(width: 48, height: 48)
                .background(Color.white, in: Circle())
                .overlay(Circle().strokeBorder(Color.white, lineWidth: 1))
                .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1),
                        radius: 16, x: 0, y: 16)
                .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.05),
                        radius: 2, x: 0, y: 4)
        }
        .buttonStyle(OverlayCapsuleButtonStyle())
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.92)) {
            isPresented = false
        }
    }
}

// MARK: - Press feedback (Flutter `isHighlighted` parity, alpha 0.7 / 0.12s)

private struct OverlayCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Slightly faster fade for row chrome (Flutter `CircleRow.isHighlighted`
/// uses 0.6 / 0.12s).
private struct RowPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Animated white sweep over the selected row's gray background — SwiftUI
/// port of `CircleRow.startShimmer`. Mirrors the Flutter
/// `CAGradientLayer.locations` animation: a 3-stop gradient
/// (base → highlight → base) the full width of the row, sliding so the
/// white peak crosses smoothly from the left to the right edge.
private struct ShimmerOverlay: View {
    @State private var animating = false

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let base = Color(hex: 0xF2F5F9)
            let highlight = Color.white.opacity(0.9)

            // Container is 2× row width so the highlight peak (at container
            // center) can travel a full row width across the visible area.
            // The `base` color matches the row background, so only the
            // moving highlight is visible — same diffuse effect as Flutter.
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
                        .linear(duration: 1.2)
                            .repeatForever(autoreverses: false)
                    ) {
                        animating = true
                    }
                }
        }
        .clipped()
        .allowsHitTesting(false)
    }
}
