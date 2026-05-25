import SwiftUI

@MainActor
@Observable
final class HomeBottomPanelViewModel {

    // MARK: - Layout constants

    let halfRatio: CGFloat = 0.42
    let expandedRatio: CGFloat = 0.08
    let peekBase: CGFloat = 85
    let inferenceBuffer: CGFloat = 32

    // MARK: - Sheet state

    var detent: HomeSheetDetent = .halfExpanded
    var sheetDrag: CGFloat = 0

    // MARK: - List state

    var listOffset: CGFloat = 0
    var contentHeight: CGFloat = 0

    // MARK: - Layout

    var headerHeight: CGFloat = 89
    var bottomInset: CGFloat = 0

    // MARK: - Section

    var section: HomeBottomSection = .members
    var sectionAnchors: [HomeBottomSection: CGFloat] = [:]

    // MARK: - Gesture bookkeeping

    var lastTranslation: CGFloat = 0
    var lastDeltaWasList = false
    var animatingTabTap = false

    // MARK: - Geometry

    func topOffset(for state: HomeSheetDetent, height: CGFloat) -> CGFloat {
        switch state {
        case .collapsed:    return height - (peekBase + bottomInset)
        case .halfExpanded: return height * (1 - halfRatio)
        case .expanded:     return height * expandedRatio
        }
    }

    func clampedOffset(_ raw: CGFloat, height: CGFloat) -> CGFloat {
        let minY = topOffset(for: .expanded,  height: height)
        let maxY = topOffset(for: .collapsed, height: height)
        if raw < minY { return minY - (minY - raw) * 0.35 }
        if raw > maxY { return maxY + (raw - maxY) * 0.35 }
        return raw
    }

    func nearestDetent(to projectedY: CGFloat, height: CGFloat) -> HomeSheetDetent {
        let candidates: [HomeSheetDetent] = [.collapsed, .halfExpanded, .expanded]
        return candidates.min {
            abs(projectedY - topOffset(for: $0, height: height)) <
            abs(projectedY - topOffset(for: $1, height: height))
        } ?? .halfExpanded
    }

    // MARK: - Section inference

    func inferTab(scrollY: CGFloat) -> HomeBottomSection {
        let order: [HomeBottomSection] = [.members, .places, .pets, .alerts]
        var current: HomeBottomSection = .members
        for tab in order {
            if let anchor = sectionAnchors[tab], scrollY >= anchor - inferenceBuffer {
                current = tab
            }
        }
        return current
    }

    func updateInferredSection() {
        guard !animatingTabTap else { return }
        let inferred = inferTab(scrollY: -listOffset)
        if inferred != section { section = inferred }
    }

    func scroll(to tab: HomeBottomSection, cardHeight: CGFloat) {
        guard let anchorY = sectionAnchors[tab] else {
            section = tab
            return
        }
        animatingTabTap = true
        section = tab
        let maxScrollDown = -max(0, contentHeight - cardHeight)
        let isLast = tab == HomeBottomSection.allCases.last
        let target: CGFloat = isLast ? maxScrollDown : max(maxScrollDown, -anchorY)
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            listOffset = target
        }
        Task {
            try? await Task.sleep(for: .milliseconds(550))
            animatingTabTap = false
        }
    }

    // MARK: - Drag dispatch

    func dispatchDelta(_ delta: CGFloat, cardHeight: CGFloat) {
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

    func finishDrag(predictedRemaining: CGFloat, height: CGFloat, cardHeight: CGFloat) {
        lastTranslation = 0
        let projectedSheet = topOffset(for: detent, height: height)
            + sheetDrag
            + predictedRemaining * 0.2
        let target = nearestDetent(to: projectedSheet, height: height)

        withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) {
            detent = target
            sheetDrag = 0
        }

        if lastDeltaWasList && (detent == .expanded || target == .expanded) {
            let maxScrollDown = -max(0, contentHeight - cardHeight)
            let momentumTarget = max(maxScrollDown, min(0, listOffset + predictedRemaining))
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
