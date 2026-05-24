import UIKit
import MapKit
import CoreLocation

final class ClusterRecompute {

    static let CLUSTER_RADIUS: CGFloat = 80

    static let CLUSTER_MAX_SPAN_DELTA: CLLocationDegrees = 0.001

    static let CULL_BUFFER: CGFloat = 300

    private let ctx: MarkerManagerContext

    init(_ ctx: MarkerManagerContext) {
        self.ctx = ctx
    }

    func execute() {
        let overlayW = ctx.overlay.bounds.width
        let overlayH = ctx.overlay.bounds.height
        guard overlayW > 0, overlayH > 0 else { return }

        let span = ctx.mapView.region.span
        let zoomedIn = span.latitudeDelta < ClusterRecompute.CLUSTER_MAX_SPAN_DELTA
            && span.longitudeDelta < ClusterRecompute.CLUSTER_MAX_SPAN_DELTA

        let newClusters: [ClusterEngine.Cluster] = zoomedIn
            ? []
            : buildClusters(overlayW: overlayW, overlayH: overlayH)

        ctx.markerToCluster.removeAll(keepingCapacity: true)
        var newClusterIds = Set<String>()
        for c in newClusters {
            if c.size < 2 { continue }
            newClusterIds.insert(c.id)
            for mid in c.memberIds {
                ctx.markerToCluster[mid] = c.id
            }
        }

        let now = CACurrentMediaTime()

        let toRemove = Set(ctx.clusters.keys).subtracting(newClusterIds)
        for rid in toRemove {
            guard let entry = ctx.clusters[rid] else { continue }
            let pt = ctx.mapView.convert(
                CLLocationCoordinate2D(latitude: entry.centerLat, longitude: entry.centerLng),
                toPointTo: ctx.overlay
            )
            entry.splitOriginX = pt.x
            entry.splitOriginY = pt.y
            entry.splitAnimStartTime = now
            entry.pendingRemove = true
            entry.formAnimStartTime = nil
        }

        for c in newClusters {
            if c.size < 2 { continue }
            let members = c.memberIds
            var sumLat = 0.0
            var sumLng = 0.0
            var validMembers = 0
            for mid in members {
                guard let mi = ctx.registry.get(mid) else { continue }
                sumLat += mi.coordinate.latitude
                sumLng += mi.coordinate.longitude
                validMembers += 1
            }
            if validMembers == 0 { continue }
            let centerLat = sumLat / Double(validMembers)
            let centerLng = sumLng / Double(validMembers)

            if let existing = ctx.clusters[c.id] {
                existing.memberIds = members
                existing.centerLat = centerLat
                existing.centerLng = centerLng
                existing.pendingRemove = false
                existing.splitAnimStartTime = nil
                if let ann = existing.annotation {
                    ann.memberIds = members
                    ann.coordinate = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng)
                }
            } else {
                let bitmap = renderClusterBitmap(clusterId: c.id, memberIds: members)
                let pinSize = CGSize(width: MarkerRenderer.pinWidth, height: MarkerRenderer.pinHeight)
                let entry = ClusterEntry(
                    id: c.id,
                    memberIds: members,
                    centerLat: centerLat,
                    centerLng: centerLng
                )
                entry.formAnimStartTime = now

                let annotation = FlutterClusterAnnotation(
                    clusterId: c.id,
                    memberIds: members,
                    coordinate: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng),
                    image: bitmap,
                    imageSize: pinSize
                )
                annotation.currentScale = 0.7
                annotation.currentAlpha = 0
                entry.annotation = annotation
                ctx.mapView.addAnnotation(annotation)

                ctx.clusters[c.id] = entry
            }
        }

        for (idx, info) in ctx.registry.infos.enumerated() {
            let id = ctx.registry.ids[idx]
            let newCid = ctx.markerToCluster[id]
            let oldCid = info.inClusterId
            if newCid == oldCid { continue }

            info.inClusterId = newCid
            if let newCid = newCid {
                guard let cluster = ctx.clusters[newCid] else { continue }
                let pt = ctx.mapView.convert(
                    CLLocationCoordinate2D(latitude: cluster.centerLat, longitude: cluster.centerLng),
                    toPointTo: ctx.overlay
                )
                let markerScreen = ctx.mapView.convert(info.coordinate, toPointTo: ctx.overlay)
                let curX = markerScreen.x
                let curY = markerScreen.y - info.h / 2
                info.clusterAnimStartX = curX
                info.clusterAnimStartY = curY
                info.clusterAnimEndX = pt.x
                info.clusterAnimEndY = pt.y
                info.clusterAnimStartAlpha = 1
                info.clusterAnimEndAlpha = 0
                info.clusterAnimHidesOnEnd = true
                info.clusterAnimStartTime = now

                if info.annotationOnMap, let ann = info.annotation {
                    ctx.mapView.removeAnnotation(ann)
                    info.annotationOnMap = false
                }
                info.view.alpha = 1
                info.view.center = CGPoint(x: curX, y: curY)
                if info.view.isHidden { info.view.isHidden = false }
            } else if let oldCid = oldCid {
                let oldCluster = ctx.clusters[oldCid]
                let originX: CGFloat
                let originY: CGFloat
                if let oldCluster = oldCluster {
                    let pt = ctx.mapView.convert(
                        CLLocationCoordinate2D(latitude: oldCluster.centerLat, longitude: oldCluster.centerLng),
                        toPointTo: ctx.overlay
                    )
                    originX = pt.x
                    originY = pt.y
                } else {
                    originX = info.classifiedScreenX
                    originY = info.classifiedScreenY
                }
                info.clusterAnimStartX = originX
                info.clusterAnimStartY = originY
                info.clusterAnimEndX = info.classifiedScreenX
                info.clusterAnimEndY = info.classifiedScreenY
                info.clusterAnimStartAlpha = 0
                info.clusterAnimEndAlpha = 1
                info.clusterAnimHidesOnEnd = false
                info.clusterAnimStartTime = now
                info.view.alpha = 0
                if info.view.isHidden { info.view.isHidden = false }
                info.justAdded = false
            }
        }

        recomputeCollisionOffsets(now: now)

        ctx.needsLayout = true
    }

    private func buildClusters(overlayW: CGFloat, overlayH: CGFloat) -> [ClusterEngine.Cluster] {
        let cullPad = ClusterRecompute.CULL_BUFFER
        let cullLeft: CGFloat = -cullPad
        let cullRight = overlayW + cullPad
        let cullTop: CGFloat = -cullPad
        let cullBottom = overlayH + cullPad

        var inputs: [ClusterEngine.Input] = []
        inputs.reserveCapacity(ctx.registry.size)

        for (idx, info) in ctx.registry.infos.enumerated() {
            let id = ctx.registry.ids[idx]
            let pt = ctx.mapView.convert(info.coordinate, toPointTo: ctx.overlay)
            let sx = pt.x
            let sy = pt.y
            if sx < cullLeft || sx > cullRight || sy < cullTop || sy > cullBottom { continue }
            inputs.append(ClusterEngine.Input(id: id, x: sx, y: sy, activitySinceMs: info.activitySinceMs))
        }
        return ClusterEngine.cluster(inputs, radiusPx: ClusterRecompute.CLUSTER_RADIUS)
    }

    private func recomputeCollisionOffsets(now: CFTimeInterval) {
        let collisionRadius: CGFloat = 80
        let spreadRadius: CGFloat = 50
        let r2 = collisionRadius * collisionRadius
        let cullPad = ClusterRecompute.CULL_BUFFER
        let overlayW = ctx.overlay.bounds.width
        let overlayH = ctx.overlay.bounds.height

        var soloIds: [String] = []
        var soloX: [CGFloat] = []
        var soloY: [CGFloat] = []

        for (idx, info) in ctx.registry.infos.enumerated() {
            let id = ctx.registry.ids[idx]
            if info.inClusterId != nil { continue }
            let pt = ctx.mapView.convert(info.coordinate, toPointTo: ctx.overlay)
            let sx = pt.x
            let sy = pt.y
            if sx < -cullPad || sx > overlayW + cullPad
                || sy < -cullPad || sy > overlayH + cullPad { continue }
            soloIds.append(id)
            soloX.append(sx)
            soloY.append(sy)
        }

        for info in ctx.registry.infos where info.inClusterId == nil {
            info.targetOffsetX = 0
            info.targetOffsetY = 0
        }

        var visited = [Bool](repeating: false, count: soloIds.count)
        for i in 0..<soloIds.count {
            if visited[i] { continue }
            var group: [Int] = [i]
            visited[i] = true
            for j in (i + 1)..<soloIds.count {
                if visited[j] { continue }
                let dx = soloX[j] - soloX[i]
                let dy = soloY[j] - soloY[i]
                if dx * dx + dy * dy <= r2 {
                    group.append(j)
                    visited[j] = true
                }
            }
            if group.count < 2 { continue }

            var sumX: CGFloat = 0
            var sumY: CGFloat = 0
            for gi in group { sumX += soloX[gi]; sumY += soloY[gi] }
            let cx = sumX / CGFloat(group.count)
            let cy = sumY / CGFloat(group.count)

            let angleStep = CGFloat(2 * Double.pi / Double(group.count))
            for (idx, gi) in group.enumerated() {
                let sx = soloX[gi]
                let sy = soloY[gi]
                let rdx = sx - cx
                let rdy = sy - cy
                let rLen = sqrt(rdx * rdx + rdy * rdy)
                let angle: CGFloat
                if rLen > 0.5 {
                    angle = atan2(rdy, rdx)
                } else {
                    angle = angleStep * CGFloat(idx) - CGFloat.pi / 2
                }
                let targetX = cx + spreadRadius * cos(angle)
                let targetY = cy + spreadRadius * sin(angle)
                guard let info = ctx.registry.get(soloIds[gi]) else { continue }
                info.targetOffsetX = targetX - sx
                info.targetOffsetY = targetY - sy
            }
        }

        for info in ctx.registry.infos where info.inClusterId == nil {
            let dx = info.targetOffsetX - info.displayOffsetX
            let dy = info.targetOffsetY - info.displayOffsetY
            if abs(dx) < 0.5 && abs(dy) < 0.5 {
                info.offsetAnimStartTime = nil
                info.displayOffsetX = info.targetOffsetX
                info.displayOffsetY = info.targetOffsetY
                continue
            }
            info.offsetAnimStartX = info.displayOffsetX
            info.offsetAnimStartY = info.displayOffsetY
            info.offsetAnimStartTime = now
        }
    }

    func renderClusterBitmap(clusterId: String, memberIds: [String]) -> UIImage {
        if let cached = ctx.clusterBitmapCache[clusterId] { return cached }

        let topIds = Array(memberIds.prefix(4))
        let avatars: [UIImage?] = topIds.map { ctx.registry.get($0)?.avatarImage }
        let initials: [String] = topIds.map { id in
            let name = ctx.registry.get(id)?.displayName.trimmingCharacters(in: .whitespaces) ?? ""
            return name.isEmpty ? "?" : String(name.first!).uppercased()
        }
        let colors: [UIColor] = topIds.map {
            ctx.registry.get($0)?.fallbackColor
                ?? UIColor(red: 0xB8/255.0, green: 0xA9/255.0, blue: 0xD9/255.0, alpha: 1)
        }

        let bitmap = ClusterRenderer.render(
            memberCount: memberIds.count,
            memberAvatars: avatars,
            memberInitials: initials,
            memberFallbackColors: colors
        )
        ctx.clusterBitmapCache[clusterId] = bitmap
        return bitmap
    }

    func invalidateClusterBitmap(_ clusterId: String) {
        ctx.clusterBitmapCache.removeValue(forKey: clusterId)
        ctx.needsLayout = true
    }
}
