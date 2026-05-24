import UIKit
import MapKit

final class EdgePillManager {

    static let SLOTS_PER_SIDE = 3
    private static let MERGE_THRESHOLD_PT: CGFloat = 60
    private static let Y_SMOOTH_FACTOR: CGFloat = 0.30
    private static let ALPHA_SMOOTH_FACTOR: CGFloat = 0.22
    private static let POP_START_SCALE: CGFloat = 0.82
    private static let POP_DURATION: CFTimeInterval = 0.22
    private static let HYSTERESIS_BIAS_PT: CGFloat = 24
    private static let STICKY_FADE_OUT: CFTimeInterval = 0.22
    private static let BRAND_FALLBACK = UIColor(
        red: 0x91/255, green: 0x71/255, blue: 0xF4/255, alpha: 1
    )
    private static let INVALID_HASH: Int = 0

    private let ctx: MarkerManagerContext
    private let onAnimationStart: () -> Void

    private let mergeThresholdPx: CGFloat
    private let hysteresisBiasPx: CGFloat

    var onPillTap: (([String]) -> Void)?

    private var leftSlots: [Slot] = []
    private var rightSlots: [Slot] = []

    private var leftCandidates: [Candidate] = []
    private var rightCandidates: [Candidate] = []
    private var leftGroups: [Group] = []
    private var rightGroups: [Group] = []
    private var candidatePool: [Candidate] = []
    private var groupPool: [Group] = []
    private var seenInClusters = Set<String>()
    private var unmatchedGroups: [Group] = []

    init(_ ctx: MarkerManagerContext, onAnimationStart: @escaping () -> Void) {
        self.ctx = ctx
        self.onAnimationStart = onAnimationStart
        self.mergeThresholdPx = EdgePillManager.MERGE_THRESHOLD_PT
        self.hysteresisBiasPx = EdgePillManager.HYSTERESIS_BIAS_PT
        self.leftSlots = (0..<EdgePillManager.SLOTS_PER_SIDE).map { _ in Slot() }
        self.rightSlots = (0..<EdgePillManager.SLOTS_PER_SIDE).map { _ in Slot() }
    }

    func update(
        overlayW: CGFloat,
        safeTop: CGFloat,
        safeBottom: CGFloat
    ) {
        recycleCandidates(&leftCandidates)
        recycleCandidates(&rightCandidates)
        recycleGroups(&leftGroups)
        recycleGroups(&rightGroups)
        seenInClusters.removeAll(keepingCapacity: true)

        let pinHalfW = MarkerRenderer.pinWidth / 2

        collectClusterCandidates(
            overlayW: overlayW,
            safeTop: safeTop, safeBottom: safeBottom,
            pinHalfW: pinHalfW
        )
        collectMarkerCandidates(
            overlayW: overlayW,
            safeTop: safeTop, safeBottom: safeBottom,
            pinHalfW: pinHalfW
        )

        leftCandidates.sort { $0.y < $1.y }
        rightCandidates.sort { $0.y < $1.y }
        groupCandidates(leftCandidates, into: &leftGroups)
        groupCandidates(rightCandidates, into: &rightGroups)

        let viewportCenterY = (safeTop + safeBottom) / 2
        assignAndRenderSide(
            slots: &leftSlots, groups: &leftGroups, isLeft: true,
            viewportCenterY: viewportCenterY, overlayW: overlayW
        )
        assignAndRenderSide(
            slots: &rightSlots, groups: &rightGroups, isLeft: false,
            viewportCenterY: viewportCenterY, overlayW: overlayW
        )
    }

    func hitTest(x: CGFloat, y: CGFloat) -> [String]? {
        return hitTestSide(slots: leftSlots, x: x, y: y) ??
               hitTestSide(slots: rightSlots, x: x, y: y)
    }

    private func hitTestSide(slots: [Slot], x: CGFloat, y: CGFloat) -> [String]? {
        for slot in slots {
            guard let view = slot.view, !view.isHidden else { continue }
            if slot.currentAlpha < 0.5 { continue }
            let frame = view.frame
            if x < frame.minX || x > frame.maxX || y < frame.minY || y > frame.maxY {
                continue
            }
            if slot.assignedMemberIds.isEmpty { continue }
            return slot.assignedMemberIds
        }
        return nil
    }

    private func collectClusterCandidates(
        overlayW: CGFloat,
        safeTop: CGFloat, safeBottom: CGFloat,
        pinHalfW: CGFloat
    ) {
        for (_, c) in ctx.clusters {
            if c.pendingRemove { continue }
            if c.onScreen { continue }

            let pt = ctx.mapView.convert(
                CLLocationCoordinate2D(latitude: c.centerLat, longitude: c.centerLng),
                toPointTo: ctx.overlay
            )
            let sx = pt.x
            let sy = pt.y
            for mid in c.memberIds { seenInClusters.insert(mid) }

            let isLeft = sideOf(sx: sx, overlayW: overlayW, halfW: pinHalfW)
            let edgeY = max(safeTop, min(safeBottom, sy))
            let members = c.memberIds.compactMap { ctx.registry.get($0) }
            let firstMember = members.first
            let cand = obtainCandidate()
            cand.entityKey = "C:\(c.id)"
            cand.avatar = firstMember?.avatarImage
            cand.fallback = firstMember?.fallbackColor ?? EdgePillManager.BRAND_FALLBACK
            cand.memberCount = c.memberIds.count
            cand.y = edgeY
            cand.label = firstLetter(firstMember?.displayName)
            cand.realIds = c.memberIds
            if isLeft { leftCandidates.append(cand) } else { rightCandidates.append(cand) }
        }
    }

    private func collectMarkerCandidates(
        overlayW: CGFloat,
        safeTop: CGFloat, safeBottom: CGFloat,
        pinHalfW: CGFloat
    ) {
        let infos = ctx.registry.infos
        let ids = ctx.registry.ids
        for i in 0..<infos.count {
            let info = infos[i]
            if info.inClusterId != nil { continue }
            let id = ids[i]
            if seenInClusters.contains(id) { continue }
            if info.classifiedOnScreen { continue }
            if info.classifiedCulled { continue }

            let pt = ctx.mapView.convert(info.coordinate, toPointTo: ctx.overlay)
            let sx = pt.x
            let sy = pt.y
            let halfW = info.w > 0 ? info.w / 2 : pinHalfW
            let isLeft = sideOf(sx: sx, overlayW: overlayW, halfW: halfW)
            let edgeY = max(safeTop, min(safeBottom, sy))

            let cand = obtainCandidate()
            cand.entityKey = "M:\(id)"
            cand.avatar = info.avatarImage
            cand.fallback = info.fallbackColor
            cand.memberCount = 1
            cand.y = edgeY
            cand.label = firstLetter(info.displayName)
            cand.realIds = [id]
            if isLeft { leftCandidates.append(cand) } else { rightCandidates.append(cand) }
        }
    }

    private func sideOf(sx: CGFloat, overlayW: CGFloat, halfW: CGFloat) -> Bool {
        if sx < halfW { return true }
        if sx > overlayW - halfW { return false }
        return sx < overlayW / 2
    }

    private func groupCandidates(_ candidates: [Candidate], into out: inout [Group]) {
        var current: Group? = nil
        for c in candidates {
            if let cur = current, abs(c.y - cur.maxY) <= mergeThresholdPx {
                addCandidateToGroup(cur, c)
                cur.maxY = c.y
            } else {
                let g = obtainGroup()
                g.minY = c.y
                g.maxY = c.y
                addCandidateToGroup(g, c)
                out.append(g)
                current = g
            }
        }
        for g in out {
            g.avgY = (g.minY + g.maxY) / 2
            g.stableKey = g.memberKeys.joined(separator: "|")
        }
    }

    private func addCandidateToGroup(_ g: Group, _ c: Candidate) {
        if g.avatars.count < 3 {
            g.avatars.append(c.avatar)
            g.fallbacks.append(c.fallback)
            g.labels.append(c.label)
        }
        g.memberKeys.append(c.entityKey)
        g.totalCount += c.memberCount
        for id in c.realIds { g.realMarkerIds.append(id) }
    }

    private func firstLetter(_ name: String?) -> String {
        guard let name = name?.trimmingCharacters(in: .whitespaces),
              !name.isEmpty else { return "" }
        for ch in name {
            if ch.isLetter || ch.isNumber {
                return String(ch).uppercased()
            }
        }
        return ""
    }

    private func assignAndRenderSide(
        slots: inout [Slot], groups: inout [Group], isLeft: Bool,
        viewportCenterY: CGFloat, overlayW: CGFloat
    ) {
        var prevKeys = Set<String>()
        for s in slots where !s.assignedKey.isEmpty {
            prevKeys.insert(s.assignedKey)
        }
        for g in groups {
            let baseDist = abs(g.avgY - viewportCenterY)
            g.priority = prevKeys.contains(g.stableKey)
                ? baseDist - hysteresisBiasPx
                : baseDist
        }
        groups.sort { $0.priority < $1.priority }
        let selectedCount = min(groups.count, EdgePillManager.SLOTS_PER_SIDE)

        let now = CACurrentMediaTime()
        unmatchedGroups.removeAll(keepingCapacity: true)
        for i in 0..<selectedCount { unmatchedGroups.append(groups[i]) }

        for slot in slots where !slot.assignedKey.isEmpty {
            if let idx = unmatchedGroups.firstIndex(where: { $0.stableKey == slot.assignedKey }) {
                let g = unmatchedGroups.remove(at: idx)
                bindSlot(slot, group: g, isLeft: isLeft, overlayW: overlayW, now: now)
            }
        }
        var freeIdx = 0
        for g in unmatchedGroups {
            while freeIdx < slots.count {
                let s = slots[freeIdx]
                if s.assignedKey.isEmpty || s.targetAlpha == 0 ||
                   !isSlotMatched(s, groups: groups, selectedCount: selectedCount) {
                    break
                }
                freeIdx += 1
            }
            if freeIdx >= slots.count { break }
            bindSlot(slots[freeIdx], group: g, isLeft: isLeft, overlayW: overlayW, now: now)
            freeIdx += 1
        }

        for slot in slots {
            if !slot.initialized { continue }
            let stillSelected = !slot.assignedKey.isEmpty &&
                isSlotMatched(slot, groups: groups, selectedCount: selectedCount)
            if stillSelected {
                slot.pendingFadeOutTime = 0
            } else {
                if slot.pendingFadeOutTime == 0 {
                    slot.pendingFadeOutTime = now
                    onAnimationStart()
                } else if now - slot.pendingFadeOutTime >= EdgePillManager.STICKY_FADE_OUT {
                    startFadeOut(slot)
                }
            }
        }

        var anyAnimating = false
        for slot in slots {
            if !slot.initialized && slot.targetAlpha == 0 { continue }
            if animateAndDrawSlot(slot, now: now) { anyAnimating = true }
        }
        if anyAnimating { onAnimationStart() }
    }

    private func isSlotMatched(_ slot: Slot, groups: [Group], selectedCount: Int) -> Bool {
        for k in 0..<selectedCount {
            if groups[k].stableKey == slot.assignedKey { return true }
        }
        return false
    }

    private func bindSlot(
        _ slot: Slot, group g: Group, isLeft: Bool,
        overlayW: CGFloat, now: CFTimeInterval
    ) {
        let view = ensureSlotView(slot)
        slot.targetY = g.avgY
        slot.targetAlpha = 1
        slot.isLeft = isLeft
        slot.overlayW = overlayW

        let contentHash = computeContentHash(g, isLeft: isLeft)
        let keyChanged = slot.assignedKey != g.stableKey
        let firstBind = !slot.initialized

        if firstBind || keyChanged {
            slot.currentY = g.avgY
            slot.currentAlpha = 0
            slot.poppedAtTime = now
            slot.initialized = true
        }
        slot.pendingFadeOutTime = 0

        if contentHash != slot.contentHash || keyChanged {
            let result = EdgePillRenderer.renderCluster(
                primaryName: "",
                avatars: g.avatars,
                fallbackColors: g.fallbacks,
                avatarLabels: g.labels,
                totalCount: g.totalCount,
                isLeft: isLeft
            )
            view.setImage(result.image, size: result.size)
            slot.pillW = result.size.width
            slot.pillH = result.size.height
            slot.contentHash = contentHash
        }
        slot.assignedKey = g.stableKey

        slot.assignedMemberIds = g.realMarkerIds
    }

    private func computeContentHash(_ g: Group, isLeft: Bool) -> Int {
        var h = isLeft ? 1 : 2
        h = 31 &* h &+ g.totalCount
        for i in 0..<g.avatars.count {
            h = 31 &* h &+ (g.avatars[i]?.hash ?? 0)
            h = 31 &* h &+ Int(g.fallbacks[i].toARGB())
            h = 31 &* h &+ g.labels[i].hashValue
        }
        return h
    }

    private func animateAndDrawSlot(_ slot: Slot, now: CFTimeInterval) -> Bool {
        guard let view = slot.view else { return false }

        let dy = slot.targetY - slot.currentY
        if abs(dy) < 0.5 { slot.currentY = slot.targetY }
        else { slot.currentY += dy * EdgePillManager.Y_SMOOTH_FACTOR }

        let da = slot.targetAlpha - slot.currentAlpha
        if abs(da) < 0.01 { slot.currentAlpha = slot.targetAlpha }
        else { slot.currentAlpha += da * EdgePillManager.ALPHA_SMOOTH_FACTOR }

        let scale = computePopScale(poppedAt: slot.poppedAtTime, now: now)

        let pw = slot.pillW
        let ph = slot.pillH
        let pillPeek = pw * 0.55
        let pillCx: CGFloat = slot.isLeft
            ? -(pw - pillPeek) / 2 + pw / 2
            : slot.overlayW + (pw - pillPeek) / 2 - pw / 2

        view.center = CGPoint(x: pillCx, y: slot.currentY)
        view.transform = CGAffineTransform(scaleX: scale, y: scale)
        view.alpha = slot.currentAlpha

        if slot.targetAlpha == 0 && slot.currentAlpha < 0.02 {
            if !view.isHidden { view.isHidden = true }
            slot.assignedKey = ""
            slot.contentHash = EdgePillManager.INVALID_HASH
            slot.initialized = false
            slot.poppedAtTime = 0
            slot.pendingFadeOutTime = 0
            slot.currentAlpha = 0
            return false
        }
        if view.isHidden { view.isHidden = false }

        let popOngoing = slot.poppedAtTime != 0 &&
            (now - slot.poppedAtTime) < EdgePillManager.POP_DURATION
        return abs(dy) > 0.5 || abs(da) > 0.01 || popOngoing
    }

    private func computePopScale(poppedAt: CFTimeInterval, now: CFTimeInterval) -> CGFloat {
        if poppedAt == 0 { return 1 }
        let elapsed = now - poppedAt
        if elapsed >= EdgePillManager.POP_DURATION { return 1 }
        let t = CGFloat(elapsed / EdgePillManager.POP_DURATION)
        let eased = t * (2 - t)
        return EdgePillManager.POP_START_SCALE +
            (1 - EdgePillManager.POP_START_SCALE) * eased
    }

    private func startFadeOut(_ slot: Slot) {
        if !slot.initialized { return }
        slot.targetAlpha = 0
    }

    private func ensureSlotView(_ slot: Slot) -> FlutterMarkerView {
        if let v = slot.view { return v }
        let v = FlutterMarkerView()
        v.isHidden = true
        ctx.overlay.addSubview(v)
        slot.view = v
        return v
    }

    private func obtainCandidate() -> Candidate {
        if let c = candidatePool.popLast() { c.reset(); return c }
        return Candidate()
    }

    private func obtainGroup() -> Group {
        if let g = groupPool.popLast() { g.reset(); return g }
        return Group()
    }

    private func recycleCandidates(_ list: inout [Candidate]) {
        candidatePool.append(contentsOf: list)
        list.removeAll(keepingCapacity: true)
    }

    private func recycleGroups(_ list: inout [Group]) {
        groupPool.append(contentsOf: list)
        list.removeAll(keepingCapacity: true)
    }

    final class Slot {
        var view: FlutterMarkerView?
        var assignedKey: String = ""
        var targetY: CGFloat = 0
        var currentY: CGFloat = 0
        var pillW: CGFloat = 0
        var pillH: CGFloat = 0
        var contentHash: Int = 0
        var initialized: Bool = false
        var isLeft: Bool = true
        var overlayW: CGFloat = 0
        var currentAlpha: CGFloat = 0
        var targetAlpha: CGFloat = 0
        var poppedAtTime: CFTimeInterval = 0
        var pendingFadeOutTime: CFTimeInterval = 0
        var assignedMemberIds: [String] = []
    }

    final class Candidate {
        var entityKey: String = ""
        var avatar: UIImage?
        var fallback: UIColor = .clear
        var memberCount: Int = 1
        var y: CGFloat = 0
        var label: String = ""
        var realIds: [String] = []

        func reset() {
            entityKey = ""
            avatar = nil
            fallback = .clear
            memberCount = 1
            y = 0
            label = ""
            realIds = []
        }
    }

    final class Group {
        var avatars: [UIImage?] = []
        var fallbacks: [UIColor] = []
        var labels: [String] = []
        var memberKeys: [String] = []
        var realMarkerIds: [String] = []
        var totalCount: Int = 0
        var minY: CGFloat = 0
        var maxY: CGFloat = 0
        var avgY: CGFloat = 0
        var stableKey: String = ""
        var priority: CGFloat = 0

        func reset() {
            avatars.removeAll(keepingCapacity: true)
            fallbacks.removeAll(keepingCapacity: true)
            labels.removeAll(keepingCapacity: true)
            memberKeys.removeAll(keepingCapacity: true)
            realMarkerIds.removeAll(keepingCapacity: true)
            totalCount = 0
            stableKey = ""
            priority = 0
        }
    }
}

private extension UIColor {
    func toARGB() -> UInt32 {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let ai = UInt32(max(0, min(255, a * 255)))
        let ri = UInt32(max(0, min(255, r * 255)))
        let gi = UInt32(max(0, min(255, g * 255)))
        let bi = UInt32(max(0, min(255, b * 255)))
        return (ai << 24) | (ri << 16) | (gi << 8) | bi
    }
}
