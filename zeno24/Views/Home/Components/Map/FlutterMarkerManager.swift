import UIKit
import MapKit
import CoreLocation

class FlutterMarkerManager {

    static let SELF_MARKER_ID = SelfMarkerController.SELF_MARKER_ID

    private let ctx: MarkerManagerContext
    private let animTick: AnimationTick
    private let clusterRecompute: ClusterRecompute
    private let selfController: SelfMarkerController
    private var layoutPassRef: LayoutPass!

    var onMarkerTap: ((String) -> Void)?

    var onClusterTap: (([String]) -> Void)?

    var edgePillSafeTopOverride: Float = -1
    var edgePillSafeBottomOverride: Float = -1

    func setEdgePillSafeTop(_ y: Float) {
        edgePillSafeTopOverride = y
        layoutPassRef.edgePillSafeTopOverride = CGFloat(y)
        scheduleNextFrame()
    }

    func setEdgePillSafeBottom(_ y: Float) {
        edgePillSafeBottomOverride = y
        layoutPassRef.edgePillSafeBottomOverride = CGFloat(y)
        scheduleNextFrame()
    }

    enum HitResult {
        case marker(String)
        case cluster([String])
        case edgePill([String])
    }

    var onEdgePillTap: (([String]) -> Void)?

    init(mapView: MKMapView, overlay: UIView) {
        self.ctx = MarkerManagerContext(mapView: mapView, overlay: overlay)
        self.animTick = AnimationTick(ctx)
        self.clusterRecompute = ClusterRecompute(ctx)

        var managerSelfRef: FlutterMarkerManager? = nil
        self.selfController = SelfMarkerController(ctx) { lat, lng in
            managerSelfRef?.updateFlutterMarker(id: SelfMarkerController.SELF_MARKER_ID, lat: lat, lng: lng)
        }

        self.layoutPassRef = LayoutPass(ctx, selfController: selfController) { [weak self] in
            self?.scheduleNextFrame()
        }

        managerSelfRef = self
    }

    func setCameraMoving(_ moving: Bool) { ctx.isCameraMoving = moving }

    func beginBatch() { ctx.batchMode = true }

    func endBatch() {
        ctx.batchMode = false
        ctx.registry.rebuild()

        var toAdd: [FlutterPointAnnotation] = []
        for info in ctx.registry.infos {
            if let ann = info.annotation, !info.annotationOnMap {
                toAdd.append(ann)
                info.annotationOnMap = true
            }
        }
        if !toAdd.isEmpty {
            ctx.mapView.addAnnotations(toAdd)
        }

        clusterRecompute.execute()
        updateAllMarkerPositions()
    }

    func addFlutterMarker(
        id: String,
        lat: Double,
        lng: Double,
        bytes: Data,
        widthDp: CGFloat,
        heightDp: CGFloat
    ) {
        if let existing = ctx.registry.get(id) {
            existing.view.removeFromSuperview()
            existing.edgePillView?.removeFromSuperview()
            if let ann = existing.annotation, existing.annotationOnMap {
                ctx.mapView.removeAnnotation(ann)
            }
        }

        let view = FlutterMarkerView(frame: .zero)
        view.setImageFromFlutter(bytes, size: CGSize(width: widthDp, height: heightDp))
        view.onTap = { [weak self] in self?.onMarkerTap?(id) }
        view.isHidden = true
        ctx.overlay.addSubview(view)

        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let info = MarkerInfo(view: view, coordinate: coord, w: widthDp, h: heightDp)

        let pinSize = CGSize(width: widthDp, height: heightDp)
        let annotation = FlutterPointAnnotation(
            markerId: id, coordinate: coord,
            image: UIImage(data: bytes), imageSize: pinSize
        )
        info.annotation = annotation
        info.annotationOnMap = true
        ctx.mapView.addAnnotation(annotation)

        ctx.registry.add(id: id, info: info)
        updateAllMarkerPositions()
    }

    func addMarkerView(
        id: String,
        lat: Double,
        lng: Double,
        view: FlutterMarkerView,
        widthDp: CGFloat,
        heightDp: CGFloat,
        displayName: String = "",
        fallbackColor: UIColor = UIColor(red: 0xF2/255.0, green: 0xF5/255.0, blue: 0xF9/255.0, alpha: 1),
        activitySinceMs: Int = 0
    ) {
        if let existing = ctx.registry.get(id) {
            existing.view.removeFromSuperview()
            existing.edgePillView?.removeFromSuperview()
            if let ann = existing.annotation, existing.annotationOnMap {
                ctx.mapView.removeAnnotation(ann)
            }
        }

        view.onTap = { [weak self] in self?.onMarkerTap?(id) }
        view.isHidden = true
        ctx.overlay.addSubview(view)

        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let info = MarkerInfo(view: view, coordinate: coord, w: widthDp, h: heightDp)
        info.displayName = displayName
        info.fallbackColor = fallbackColor
        info.activitySinceMs = activitySinceMs

        let annotation = FlutterPointAnnotation(
            markerId: id, coordinate: coord,
            image: view.currentImage, imageSize: CGSize(width: widthDp, height: heightDp)
        )
        info.annotation = annotation

        if ctx.batchMode {
            info.annotationOnMap = false
            ctx.registry.markers[id] = info
        } else {
            info.annotationOnMap = true
            ctx.mapView.addAnnotation(annotation)
            ctx.registry.add(id: id, info: info)
            updateAllMarkerPositions()
        }
    }

    func setMarkerAvatar(id: String, image: UIImage) {
        guard let info = ctx.registry.get(id) else { return }
        info.avatarImage = image
        if let cid = info.inClusterId { clusterRecompute.invalidateClusterBitmap(cid) }
    }

    func setMarkerImage(id: String, image: UIImage) {
        guard let info = ctx.registry.get(id) else { return }
        let size = CGSize(width: MarkerRenderer.pinWidth, height: MarkerRenderer.pinHeight)
        info.view.setImage(image, size: size)
        if let ann = info.annotation {
            ann.image = image
            ann.imageSize = size
            if let av = ctx.mapView.view(for: ann) as? FlutterAnnotationView {
                av.updateImage(image)
            }
        }
    }

    func hasMarker(id: String) -> Bool { ctx.registry.has(id) }
    func allMarkerIds() -> [String] { ctx.registry.allIds() }

    func updateFlutterMarker(id: String, lat: Double, lng: Double) {
        guard let info = ctx.registry.get(id) else { return }
        info.moveAnimStartLat = info.coordinate.latitude
        info.moveAnimStartLng = info.coordinate.longitude
        info.moveAnimEndLat = lat
        info.moveAnimEndLng = lng
        info.moveAnimStartTime = CACurrentMediaTime()
        scheduleNextFrame()
    }

    func coordinate(forMarkerId id: String) -> CLLocationCoordinate2D? {
        guard let info = ctx.registry.get(id) else { return nil }
        if info.moveAnimStartTime != nil {
            return CLLocationCoordinate2D(latitude: info.moveAnimEndLat, longitude: info.moveAnimEndLng)
        }
        return info.coordinate
    }

    func removeMarker(id: String) {
        guard let info = ctx.registry.remove(id) else { return }
        info.view.removeFromSuperview()
        info.edgePillView?.removeFromSuperview()
        if let ann = info.annotation, info.annotationOnMap {
            ctx.mapView.removeAnnotation(ann)
            info.annotationOnMap = false
        }
        ctx.markerToCluster.removeValue(forKey: id)
    }

    func clearAllMarkers() {
        for info in ctx.registry.markers.values {
            info.view.removeFromSuperview()
            info.edgePillView?.removeFromSuperview()
            if let ann = info.annotation, info.annotationOnMap {
                ctx.mapView.removeAnnotation(ann)
                info.annotationOnMap = false
            }
        }
        ctx.registry.clear()
        for c in ctx.clusters.values {
            c.edgePillView?.removeFromSuperview()
            if let ann = c.annotation {
                ctx.mapView.removeAnnotation(ann)
            }
        }
        ctx.clusters.removeAll()
        ctx.markerToCluster.removeAll()
        ctx.clusterBitmapCache.removeAll()
    }

    func setSelfMarker(bytes: Data, widthDp: CGFloat, heightDp: CGFloat) {
        selfController.setSelfMarker(bytes: bytes, widthDp: widthDp, heightDp: heightDp)
    }

    func setSelfMarkerImage(_ image: UIImage, size: CGSize) {
        selfController.setSelfImage(image, size: size)
    }

    func updateSelfLocation(lat: Double, lng: Double) {
        selfController.updateLocation(lat: lat, lng: lng)
    }

    func updateSelfHeading(degrees: Double) {
        selfController.updateHeading(degrees)
    }

    var currentSelfCoordinate: CLLocationCoordinate2D? {
        selfController.currentSelfCoordinate()
    }

    func ensureSelfHeadingView() {
        selfController.ensureHeadingView()
    }

    func recomputeClusters() {
        clusterRecompute.execute()
        scheduleNextFrame()
    }

    func updateAllMarkerPositions() {
        if animTick.hasActiveAnimation() {
            animTick.tickInterp(CACurrentMediaTime())
        }
        layoutPassRef.execute()
    }

    func requestLayout() {
        ctx.needsLayout = true
        scheduleNextFrame()
    }

    func findHitAt(_ point: CGPoint) -> HitResult? {
        if let memberIds = layoutPassRef.findEdgePillHitAt(x: point.x, y: point.y) {
            return .edgePill(memberIds)
        }
        return nil
    }

    var onScheduleNextFrame: (() -> Void)?

    func scheduleNextFrame() {
        onScheduleNextFrame?()
    }
}
