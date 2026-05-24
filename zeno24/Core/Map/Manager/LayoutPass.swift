import UIKit
import MapKit
import CoreLocation

final class LayoutPass {

    static let SMOOTHING_TAU: CFTimeInterval = 0.025
    static let BREATHING_PERIOD: CFTimeInterval = 2.4
    static let BREATHING_AMPLITUDE: CGFloat = 0.04

    private let ctx: MarkerManagerContext
    private let selfController: SelfMarkerController
    private let edgePillManager: EdgePillManager
    private let onAnimationStart: () -> Void

    private var smoothingFactor: CGFloat = 0.5
    private var breathingScale: CGFloat = 1.0

    var edgePillSafeTopOverride: CGFloat = -1
    var edgePillSafeBottomOverride: CGFloat = -1

    var onEdgePillTap: (([String]) -> Void)? {
        get { edgePillManager.onPillTap }
        set { edgePillManager.onPillTap = newValue }
    }

    init(
        _ ctx: MarkerManagerContext,
        selfController: SelfMarkerController,
        onAnimationStart: @escaping () -> Void
    ) {
        self.ctx = ctx
        self.selfController = selfController
        self.onAnimationStart = onAnimationStart
        self.edgePillManager = EdgePillManager(ctx, onAnimationStart: onAnimationStart)
    }

    func findEdgePillHitAt(x: CGFloat, y: CGFloat) -> [String]? {
        return edgePillManager.hitTest(x: x, y: y)
    }

    func execute() {
        let overlayW = ctx.overlay.bounds.width
        let overlayH = ctx.overlay.bounds.height
        guard overlayW > 0, overlayH > 0 else { return }

        let now = CACurrentMediaTime()
        let dt = ctx.lastLayoutTime == 0 ? 0 : now - ctx.lastLayoutTime
        ctx.lastLayoutTime = now
        if dt <= 0 || dt > 0.1 || ctx.isCameraMoving {
            smoothingFactor = 1
        } else {
            smoothingFactor = CGFloat(1.0 - exp(-dt / LayoutPass.SMOOTHING_TAU))
        }

        let phase = now.truncatingRemainder(dividingBy: LayoutPass.BREATHING_PERIOD)
            / LayoutPass.BREATHING_PERIOD
        let wave = sin(phase * 2.0 * .pi)
        breathingScale = 1.0 + CGFloat(wave) * LayoutPass.BREATHING_AMPLITUDE

        let (safeTop, safeBottom) = defaultSafeAreaBounds(overlayH: overlayH)

        let pillSafeTop = (edgePillSafeTopOverride > 0 && edgePillSafeTopOverride > safeTop)
            ? edgePillSafeTopOverride : safeTop
        let pillSafeBottomRaw = (edgePillSafeBottomOverride > 0 && edgePillSafeBottomOverride < safeBottom)
            ? edgePillSafeBottomOverride : safeBottom
        let pillSafeBottom = pillSafeBottomRaw > pillSafeTop + 40 ?
            pillSafeBottomRaw : pillSafeTop + 40

        ctx.edgeResolver.beginPass()

        let ids = ctx.registry.ids
        let infos = ctx.registry.infos
        let n = infos.count
        for idx in 0..<n {
            let id = ids[idx]
            let info = infos[idx]
            let pt = ctx.mapView.convert(info.coordinate, toPointTo: ctx.overlay)
            let sx = pt.x
            let sy = pt.y

            info.classifiedCulled = false

            let displayX = sx + info.displayOffsetX
            let displayY = sy + info.displayOffsetY
            info.classifiedScreenX = displayX
            info.classifiedScreenY = displayY

            let halfW = info.w / 2
            let goesLeft = sx < halfW
            let goesRight = sx > overlayW - halfW
            let inY = sy >= safeTop && sy <= safeBottom

            if !goesLeft && !goesRight && inY {
                info.classifiedOnScreen = true
            } else {
                info.classifiedOnScreen = false
                let isLeft: Bool
                if goesLeft { isLeft = true }
                else if goesRight { isLeft = false }
                else { isLeft = sx < overlayW / 2 }
                info.classifiedIsLeftEdge = isLeft
                if isLeft {
                    ctx.edgeResolver.pushLeft(id: id, y: sy)
                } else {
                    ctx.edgeResolver.pushRight(id: id, y: sy)
                }
            }
        }

        ctx.edgeResolver.resolve(safeTop: safeTop, safeBottom: safeBottom) { id in
            self.ctx.registry.get(id)?.w ?? 60
        }
        ctx.edgeResolver.forEachLeft { id, y in
            self.ctx.registry.get(id)?.classifiedEdgeY = y
        }
        ctx.edgeResolver.forEachRight { id, y in
            self.ctx.registry.get(id)?.classifiedEdgeY = y
        }

        for info in infos {
            if info.classifiedCulled {
                applyCulled(info)
            } else if info.inClusterId != nil {
                applyClusterMember(info, now: now)
            } else if info.classifiedOnScreen {
                applyOnScreen(info, now: now)
            } else {
                applyEdge(info)
            }
        }

        applyClusters(
            overlayW: overlayW, overlayH: overlayH,
            safeTop: safeTop, safeBottom: safeBottom,
            now: now
        )

        edgePillManager.update(
            overlayW: overlayW,
            safeTop: pillSafeTop,
            safeBottom: pillSafeBottom
        )

        selfController.applyHeading(overlayW: overlayW, overlayH: overlayH)
    }

    private func defaultSafeAreaBounds(overlayH: CGFloat) -> (top: CGFloat, bottom: CGFloat) {
        var ins = UIEdgeInsets.zero
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let win = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first {
            ins = win.safeAreaInsets
        }
        return (ins.top + 20, overlayH - ins.bottom - 40)
    }

    private func applyCulled(_ info: MarkerInfo) {
        if !info.view.isHidden {
            info.view.isHidden = true
            info.view.stopPulseAnimation()
        }
        info.snapAnimStartTime = nil
        info.returnAnimStartTime = nil
        info.onScreen = false
        info.justAdded = true
    }

    private func applyClusterMember(_ info: MarkerInfo, now: CFTimeInterval) {
        if let animStart = info.clusterAnimStartTime, info.clusterAnimHidesOnEnd {
            let elapsed = now - animStart
            let raw = elapsed / info.clusterAnimDuration
            let t = AnimationTick.decelT(raw)
            let cx = AnimationTick.lerp(info.clusterAnimStartX, info.clusterAnimEndX, t)
            let cy = AnimationTick.lerp(info.clusterAnimStartY, info.clusterAnimEndY, t)
            let a = AnimationTick.lerp(info.clusterAnimStartAlpha, info.clusterAnimEndAlpha, t)
            info.view.center = CGPoint(x: cx, y: cy - info.h / 2)
            info.view.alpha = a
            if info.view.isHidden { info.view.isHidden = false }
            if raw >= 1.0 {
                info.clusterAnimStartTime = nil
                info.view.alpha = 1
                info.view.isHidden = true
                info.view.stopPulseAnimation()
            }
        } else {
            if !info.view.isHidden {
                info.view.isHidden = true
                info.view.stopPulseAnimation()
            }
        }
        info.snapAnimStartTime = nil
        info.returnAnimStartTime = nil
        info.onScreen = false
    }

    private func applyOnScreen(_ info: MarkerInfo, now: CFTimeInterval) {
        let cx = info.classifiedScreenX
        let cy = info.classifiedScreenY - info.h / 2

        if let animStart = info.clusterAnimStartTime, !info.clusterAnimHidesOnEnd {
            if info.view.isHidden { info.view.isHidden = false }
            let elapsed = now - animStart
            let raw = elapsed / info.clusterAnimDuration
            let t = AnimationTick.decelT(raw)
            info.clusterAnimEndX = cx
            info.clusterAnimEndY = cy
            let xCenter = AnimationTick.lerp(info.clusterAnimStartX, info.clusterAnimEndX, t)
            let yCenter = AnimationTick.lerp(info.clusterAnimStartY, info.clusterAnimEndY, t)
            let a = AnimationTick.lerp(info.clusterAnimStartAlpha, info.clusterAnimEndAlpha, t)
            info.view.center = CGPoint(x: xCenter, y: yCenter)
            info.view.alpha = a
            if raw >= 1.0 {
                info.clusterAnimStartTime = nil
                info.view.alpha = 1
                info.view.center = CGPoint(x: cx, y: cy)
                if let ann = info.annotation, !info.annotationOnMap {
                    ctx.mapView.addAnnotation(ann)
                    info.annotationOnMap = true
                    DispatchQueue.main.async { [weak info] in
                        info?.view.isHidden = true
                    }
                }
            }
            info.onScreen = true
            info.justAdded = false
            return
        }

        if let ann = info.annotation, !info.annotationOnMap {
            ctx.mapView.addAnnotation(ann)
            info.annotationOnMap = true
        }
        if !info.view.isHidden { info.view.isHidden = true }
        info.onScreen = true
        info.justAdded = false
    }

    private func applyEdge(_ info: MarkerInfo) {
        if !info.view.isHidden {
            info.view.isHidden = true
            info.view.stopPulseAnimation()
        }
        info.returnAnimStartTime = nil
        info.snapAnimStartTime = nil
        info.onScreen = false

        if info.annotationOnMap, let ann = info.annotation {
            ctx.mapView.removeAnnotation(ann)
            info.annotationOnMap = false
        }
    }

    private func applyClusters(
        overlayW: CGFloat, overlayH: CGFloat,
        safeTop: CGFloat, safeBottom: CGFloat,
        now: CFTimeInterval
    ) {
        if ctx.clusters.isEmpty { return }
        let pinW = MarkerRenderer.pinWidth
        let halfW = pinW / 2

        var toRemove: [String] = []

        for (_, c) in ctx.clusters {
            let pt = ctx.mapView.convert(
                CLLocationCoordinate2D(latitude: c.centerLat, longitude: c.centerLng),
                toPointTo: ctx.overlay
            )
            c.classifiedScreenX = pt.x
            c.classifiedScreenY = pt.y
            c.classifiedCulled = false

            let goesLeft = pt.x < halfW
            let goesRight = pt.x > overlayW - halfW
            let inY = pt.y >= safeTop && pt.y <= safeBottom
            c.onScreen = !goesLeft && !goesRight && inY
            c.justAdded = false

            var scaleVal: CGFloat = 1
            var alpha: CGFloat = 1
            if let formStart = c.formAnimStartTime {
                let elapsed = now - formStart
                let raw = elapsed / c.formAnimDuration
                let t = AnimationTick.decelT(raw)
                scaleVal = AnimationTick.lerp(0.7, 1.0, t)
                alpha = AnimationTick.lerp(0, 1, t)
                if raw >= 1.0 {
                    c.formAnimStartTime = nil
                    scaleVal = 1; alpha = 1
                }
            } else if let splitStart = c.splitAnimStartTime {
                let elapsed = now - splitStart
                let raw = elapsed / c.splitAnimDuration
                let t = AnimationTick.decelT(raw)
                scaleVal = AnimationTick.lerp(1, 0.7, t)
                alpha = AnimationTick.lerp(1, 0, t)
                if raw >= 1.0 {
                    c.splitAnimStartTime = nil
                    if c.pendingRemove { toRemove.append(c.id) }
                }
            }

            let applySmoothing = c.formAnimStartTime == nil && c.splitAnimStartTime == nil
            let finalScale = applySmoothing ? scaleVal * breathingScale : scaleVal

            if let ann = c.annotation {
                ann.currentScale = finalScale
                ann.currentAlpha = alpha
                if let av = ctx.mapView.view(for: ann) as? FlutterClusterAnnotationView {
                    av.applyScaleAlpha(scale: finalScale, alpha: alpha)
                }
            }
        }

        for rid in toRemove {
            if let entry = ctx.clusters.removeValue(forKey: rid) {
                if let ann = entry.annotation {
                    ctx.mapView.removeAnnotation(ann)
                }
                entry.edgePillView?.removeFromSuperview()
                ctx.clusterBitmapCache.removeValue(forKey: rid)
            }
        }
    }

}
