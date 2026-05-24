import SwiftUI

/// Persistent bottom sheet — SwiftUI port of the Flutter iOS UIKit
/// `HomeBottomSheet` + `HomeMembersList`. All four sections live in one
/// long vertical scroll; the tab row both reflects and controls the
/// current scroll position:
///
///   • Tap a tab → scrolls the content to that section's anchor.
///   • Drag the content past a section's anchor → tab updates to that section.
///   • Drag interactions also drive the 3-detent sheet (collapsed / half /
///     expanded) with rubber-band + spring snap.
struct HomeBottomPanel: View {
    let store: HomeStore
    let members: [MarkerModel]

    /// Measured by `MainView` via `TabBarHeightPreferenceKey`. Subtracted
    /// from the sheet's usable height so content never disappears under
    /// the bar regardless of device safe-area handling.
    @Environment(\.tabBarHeight) private var tabBarHeight

    // MARK: - Layout constants (1:1 with UIKit)

    private let halfRatio: CGFloat = 0.42
    private let expandedRatio: CGFloat = 0.08
    private let peekBase: CGFloat = 85
    /// Vertical buffer that decides which section is "active" while
    /// scrolling — matches the UIKit `petsThreshold = anchorY - 32`.
    private let inferenceBuffer: CGFloat = 32

    // MARK: - State

    @State private var detent: HomeSheetDetent = .halfExpanded
    @State private var sheetDrag: CGFloat = 0
    @State private var listOffset: CGFloat = 0
    @State private var lastTranslation: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var section: HomeBottomSection = .members
    @State private var sectionAnchors: [HomeBottomSection: CGFloat] = [:]
    /// Whether the most recent delta moved the inner list (vs. the sheet).
    /// On release this drives deceleration so the list keeps scrolling
    /// — mirrors `UIScrollView` momentum.
    @State private var lastDeltaWasList = false
    /// Suppress scroll-driven `section` updates while we're animating a
    /// tap target into view (otherwise the inferred section ping-pongs
    /// through the intermediate anchors and the pill flickers).
    @State private var animatingTabTap = false

    var body: some View {
        GeometryReader { proxy in
            // Subtract the *measured* tab-bar height (reported via
            // `TabBarHeightPreferenceKey`) so the sheet bounds always
            // stop above the bar — independent of safe-area quirks.
            let height = proxy.size.height - tabBarHeight
            let safeBottom: CGFloat = 0
            let baseY = topOffset(for: detent, height: height, safeBottom: safeBottom)
            let liveY = clampedOffset(baseY + sheetDrag, height: height, safeBottom: safeBottom)
            let visibleCardHeight = max(0, height - liveY - peekBase)

            sheetContent(cardHeight: visibleCardHeight)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .offset(y: liveY)
                .gesture(unifiedGesture(height: height, safeBottom: safeBottom,
                                        cardHeight: visibleCardHeight))
                .animation(.spring(response: 0.32, dampingFraction: 0.85), value: detent)
        }
        .ignoresSafeArea()
    }

    // MARK: - Content

    private func sheetContent(cardHeight: CGFloat) -> some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color(hex: 0xD3D5D8))
                .frame(width: 44, height: 5)
                .padding(.top, 10)

            Spacer().frame(height: 20)

            HomeNavRow(active: section) { tapped in
                Haptics.selection()
                scroll(to: tapped, cardHeight: cardHeight)
            }
            .padding(.horizontal, 10)

            Spacer().frame(height: 10)

            HomeSectionCard(
                scrollOffset: listOffset,
                visibleHeight: cardHeight,
                contentHeight: $contentHeight
            ) {
                unifiedScrollContent
            }
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                Rectangle().fill(.regularMaterial)
                LinearGradient(
                    colors: [
                        Color(hex: 0xF8F7FF).opacity(0.7),
                        Color(hex: 0xF6D2FF).opacity(0.7),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: 30, topTrailing: 30)
            )
        )
        .contentShape(Rectangle())
    }

    /// All four sections in one vertical stack. Each section reports its
    /// Y origin (within the `scroll` coordinate space) so the tab row can
    /// jump to it and so the active tab can be inferred from the current
    /// scroll position.
    private var unifiedScrollContent: some View {
        VStack(spacing: 0) {
            anchored(.members) { HomeMembersContent(members: members) }
            anchored(.places)  { HomePlacesContent() }
            anchored(.pets)    { HomePetsContent() }
            anchored(.alerts)  { HomeAlertsContent() }
        }
        .coordinateSpace(name: Self.scrollSpace)
        .onPreferenceChange(SectionAnchorKey.self) { anchors in
            sectionAnchors.merge(anchors) { _, new in new }
        }
    }

    @ViewBuilder
    private func anchored<Content: View>(
        _ tab: HomeBottomSection,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: SectionAnchorKey.self,
                        value: [tab: proxy.frame(in: .named(Self.scrollSpace)).minY]
                    )
                }
            )
    }

    // MARK: - Scroll → tab inference

    private func inferTab(scrollY: CGFloat) -> HomeBottomSection {
        // Walk sections in order; the last section whose anchor (minus
        // buffer) is ≤ scrollY wins. Mirrors UIKit's `inferredTab` ladder.
        let order: [HomeBottomSection] = [.members, .places, .pets, .alerts]
        var current: HomeBottomSection = .members
        for tab in order {
            if let anchor = sectionAnchors[tab], scrollY >= anchor - inferenceBuffer {
                current = tab
            }
        }
        return current
    }

    private func updateInferredSection() {
        guard !animatingTabTap else { return }
        let scrollY = -listOffset
        let inferred = inferTab(scrollY: scrollY)
        if inferred != section { section = inferred }
    }

    private func scroll(to tab: HomeBottomSection, cardHeight: CGFloat) {
        guard let anchorY = sectionAnchors[tab] else {
            section = tab
            return
        }
        animatingTabTap = true
        section = tab
        let maxScrollDown = -max(0, contentHeight - cardHeight)
        let target = max(maxScrollDown, -anchorY)
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            listOffset = target
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            animatingTabTap = false
        }
    }

    // MARK: - Geometry

    private func topOffset(for state: HomeSheetDetent, height: CGFloat, safeBottom: CGFloat) -> CGFloat {
        switch state {
        case .collapsed:    return height - (peekBase + safeBottom)
        case .halfExpanded: return height * (1 - halfRatio)
        case .expanded:     return height * expandedRatio
        }
    }

    private func clampedOffset(_ raw: CGFloat, height: CGFloat, safeBottom: CGFloat) -> CGFloat {
        let minY = topOffset(for: .expanded, height: height, safeBottom: safeBottom)
        let maxY = topOffset(for: .collapsed, height: height, safeBottom: safeBottom)
        if raw < minY { return minY - (minY - raw) * 0.35 }
        if raw > maxY { return maxY + (raw - maxY) * 0.35 }
        return raw
    }

    private func nearestDetent(to projectedY: CGFloat, height: CGFloat, safeBottom: CGFloat) -> HomeSheetDetent {
        let candidates: [HomeSheetDetent] = [.collapsed, .halfExpanded, .expanded]
        return candidates.min { a, b in
            let aDist = abs(projectedY - topOffset(for: a, height: height, safeBottom: safeBottom))
            let bDist = abs(projectedY - topOffset(for: b, height: height, safeBottom: safeBottom))
            return aDist < bDist
        } ?? .halfExpanded
    }

    // MARK: - Gesture

    private func unifiedGesture(height: CGFloat, safeBottom: CGFloat, cardHeight: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let delta = value.translation.height - lastTranslation
                lastTranslation = value.translation.height
                dispatchDelta(delta, cardHeight: cardHeight)
                updateInferredSection()
            }
            .onEnded { value in
                lastTranslation = 0
                let remaining = value.predictedEndTranslation.height - value.translation.height
                let projectedSheet = topOffset(for: detent, height: height, safeBottom: safeBottom)
                    + sheetDrag
                    + remaining * 0.2
                let target = nearestDetent(to: projectedSheet, height: height, safeBottom: safeBottom)
                withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
                    detent = target
                    sheetDrag = 0
                }

                // List deceleration: only if we were just scrolling the list.
                // Mirrors `UIScrollView` `.normal` deceleration — easeOut over
                // ~500ms covers the velocity-projected distance.
                if lastDeltaWasList && (detent == .expanded || target == .expanded) {
                    let maxScrollDown = -max(0, contentHeight - cardHeight)
                    let momentumTarget = max(maxScrollDown, min(0, listOffset + remaining))
                    if momentumTarget != listOffset {
                        withAnimation(.easeOut(duration: 0.5)) {
                            listOffset = momentumTarget
                        }
                    }
                }
                lastDeltaWasList = false
                updateInferredSection()
            }
    }

    private func dispatchDelta(_ delta: CGFloat, cardHeight: CGFloat) {
        guard detent == .expanded else {
            sheetDrag += delta
            lastDeltaWasList = false
            return
        }

        let maxScrollDown = -max(0, contentHeight - cardHeight)

        if delta > 0 {
            if listOffset < 0 {
                let needed = -listOffset
                let consumed = min(needed, delta)
                listOffset += consumed
                let remaining = delta - consumed
                if remaining > 0 {
                    sheetDrag += remaining
                    lastDeltaWasList = false
                } else {
                    lastDeltaWasList = true
                }
                return
            }
            sheetDrag += delta
            lastDeltaWasList = false
        } else {
            if listOffset > maxScrollDown {
                let available = listOffset - maxScrollDown
                let consume = min(available, -delta)
                listOffset -= consume
                lastDeltaWasList = true
                return
            }
            sheetDrag += delta
            lastDeltaWasList = false
        }
    }

    // MARK: - Constants

    private static let scrollSpace = "HomeSheetScroll"
}

// MARK: - Section anchor preference

private struct SectionAnchorKey: PreferenceKey {
    static let defaultValue: [HomeBottomSection: CGFloat] = [:]
    static func reduce(value: inout [HomeBottomSection: CGFloat],
                       nextValue: () -> [HomeBottomSection: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}

// MARK: - Models

enum HomeSheetDetent: Hashable {
    case collapsed, halfExpanded, expanded
}

enum HomeBottomSection: String, CaseIterable, Hashable, Identifiable {
    case members, places, pets, alerts
    var id: String { rawValue }

    var title: String {
        switch self {
        case .members: return AppStrings.Home.members
        case .places:  return AppStrings.Home.places
        case .pets:    return AppStrings.Home.pets
        case .alerts:  return AppStrings.Home.alerts
        }
    }

    var iconAsset: String {
        switch self {
        case .members: return AppVectors.members
        case .places:  return AppVectors.earth
        case .pets:    return AppVectors.pets
        case .alerts:  return AppVectors.alerts
        }
    }
}
