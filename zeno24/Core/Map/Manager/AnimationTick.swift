import UIKit
import CoreLocation
import MapKit

final class AnimationTick {
    private let ctx: MarkerManagerContext

    init(_ ctx: MarkerManagerContext) {
        self.ctx = ctx
    }

    func hasActiveAnimation() -> Bool {
        for info in ctx.registry.infos {
            if info.moveAnimStartTime != nil
                || info.returnAnimStartTime != nil
                || info.snapAnimStartTime != nil
                || info.clusterAnimStartTime != nil
                || info.offsetAnimStartTime != nil {
                return true
            }

            if info.smoothedInitialized && info.classifiedOnScreen {
                let dx = info.classifiedScreenX - info.smoothedScreenX
                let dy = info.classifiedScreenY - info.smoothedScreenY
                if abs(dx) > 0.5 || abs(dy) > 0.5 { return true }
            }
        }
        for c in ctx.clusters.values {
            if c.formAnimStartTime != nil || c.splitAnimStartTime != nil { return true }
        }

        if !ctx.registry.infos.isEmpty || !ctx.clusters.isEmpty { return true }
        return false
    }

    func tickInterp(_ now: CFTimeInterval) {
        for info in ctx.registry.infos {
            if let startTime = info.moveAnimStartTime {
                let elapsed = now - startTime
                let t = AnimationTick.decelT(elapsed / info.moveAnimDuration)
                let curLat = AnimationTick.lerpD(info.moveAnimStartLat, info.moveAnimEndLat, Double(t))
                let curLng = AnimationTick.lerpD(info.moveAnimStartLng, info.moveAnimEndLng, Double(t))
                info.coordinate = CLLocationCoordinate2D(latitude: curLat, longitude: curLng)
                info.annotation?.coordinate = info.coordinate
                if elapsed >= info.moveAnimDuration {
                    info.coordinate = CLLocationCoordinate2D(
                        latitude: info.moveAnimEndLat,
                        longitude: info.moveAnimEndLng
                    )
                    info.annotation?.coordinate = info.coordinate
                    info.moveAnimStartTime = nil
                }
            }

            if let offStart = info.offsetAnimStartTime {
                let elapsed = now - offStart
                let t = AnimationTick.decelT(elapsed / info.offsetAnimDuration)
                info.displayOffsetX = AnimationTick.lerp(info.offsetAnimStartX, info.targetOffsetX, t)
                info.displayOffsetY = AnimationTick.lerp(info.offsetAnimStartY, info.targetOffsetY, t)
                if elapsed >= info.offsetAnimDuration {
                    info.displayOffsetX = info.targetOffsetX
                    info.displayOffsetY = info.targetOffsetY
                    info.offsetAnimStartTime = nil
                }
            }
        }
    }

    static func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }

    static func lerpD(_ a: Double, _ b: Double, _ t: Double) -> Double {
        a + (b - a) * t
    }

    static func decelT(_ raw: Double) -> CGFloat {
        let clamped = min(1.0, max(0.0, raw))
        return CGFloat(1.0 - pow(1.0 - clamped, 2.0))
    }
}
