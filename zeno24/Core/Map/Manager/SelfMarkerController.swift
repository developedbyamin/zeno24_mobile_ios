import UIKit
import MapKit
import CoreLocation

final class SelfMarkerController {

    static let SELF_MARKER_ID = "__self__"

    private let ctx: MarkerManagerContext
    private let onLocationUpdate: (Double, Double) -> Void

    private var headingAnnotation: FlutterHeadingAnnotation?
    private var headingOnMap: Bool = false
    private var selfHeadingW: CGFloat = MarkerRenderer.headingWidth
    private var selfHeadingH: CGFloat = MarkerRenderer.headingHeight
    private var selfLat: Double?
    private var selfLng: Double?
    private var selfHeadingDeg: CGFloat = 0
    private var selfView: FlutterMarkerView?
    private var selfW: CGFloat = 0
    private var selfH: CGFloat = 0

    init(_ ctx: MarkerManagerContext, onLocationUpdate: @escaping (Double, Double) -> Void) {
        self.ctx = ctx
        self.onLocationUpdate = onLocationUpdate
    }

    func ensureHeadingView() {
        if headingAnnotation != nil { return }
        let img = MarkerRenderer.renderHeadingIndicator()
        let ann = FlutterHeadingAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: selfLat ?? 0, longitude: selfLng ?? 0),
            image: img,
            imageSize: CGSize(width: selfHeadingW, height: selfHeadingH)
        )
        ann.headingDegrees = selfHeadingDeg
        headingAnnotation = ann
    }

    func setSelfImage(_ image: UIImage, size: CGSize) {
        selfW = size.width
        selfH = size.height
        ensureHeadingView()
        ensureSelfRegistered(image: image, bytes: nil, widthDp: size.width, heightDp: size.height)
    }

    func setSelfMarker(bytes: Data, widthDp: CGFloat, heightDp: CGFloat) {
        selfW = widthDp
        selfH = heightDp
        ensureHeadingView()
        ensureSelfRegistered(image: nil, bytes: bytes, widthDp: widthDp, heightDp: heightDp)
    }

    private func ensureSelfRegistered(
        image: UIImage?,
        bytes: Data?,
        widthDp: CGFloat,
        heightDp: CGFloat
    ) {
        let id = SelfMarkerController.SELF_MARKER_ID
        let size = CGSize(width: widthDp, height: heightDp)
        let resolvedImage: UIImage? = image ?? bytes.flatMap { UIImage(data: $0) }

        if let existing = ctx.registry.get(id) {
            if let image = image { existing.view.setImage(image, size: size) }
            else if let bytes = bytes { existing.view.setImageFromFlutter(bytes, size: size) }
            if let ann = existing.annotation {
                ann.image = resolvedImage
                ann.imageSize = size
                if let av = ctx.mapView.view(for: ann) as? FlutterAnnotationView {
                    av.updateImage(resolvedImage)
                }
            }
            return
        }

        let view = FlutterMarkerView(frame: .zero)
        if let image = image { view.setImage(image, size: size) }
        else if let bytes = bytes { view.setImageFromFlutter(bytes, size: size) }
        view.isHidden = true
        ctx.overlay.addSubview(view)

        let coord = CLLocationCoordinate2D(
            latitude: selfLat ?? 0,
            longitude: selfLng ?? 0
        )
        let info = MarkerInfo(view: view, coordinate: coord, w: widthDp, h: heightDp)
        info.displayName = "You"

        let pinAnn = FlutterPointAnnotation(
            markerId: id, coordinate: coord,
            image: resolvedImage, imageSize: size
        )
        pinAnn.zPriorityRaw = 1000
        info.annotation = pinAnn
        info.annotationOnMap = true
        ctx.mapView.addAnnotation(pinAnn)

        ctx.registry.add(id: id, info: info)
        selfView = view
    }

    func updateLocation(lat: Double, lng: Double) {
        selfLat = lat
        selfLng = lng

        if ctx.registry.has(SelfMarkerController.SELF_MARKER_ID) {
            onLocationUpdate(lat, lng)
        }
    }

    func updateHeading(_ degrees: Double) {
        selfHeadingDeg = CGFloat(degrees)
        headingAnnotation?.headingDegrees = selfHeadingDeg
        if let ann = headingAnnotation,
           let view = ctx.mapView.view(for: ann) as? FlutterHeadingAnnotationView {
            view.applyHeading(selfHeadingDeg)
        }
    }

    func currentSelfCoordinate() -> CLLocationCoordinate2D? {
        if let info = ctx.registry.get(SelfMarkerController.SELF_MARKER_ID) {
            return info.coordinate
        }
        guard let lat = selfLat, let lng = selfLng else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }

    func applyHeading(overlayW: CGFloat, overlayH: CGFloat) {
        guard let info = ctx.registry.get(SelfMarkerController.SELF_MARKER_ID),
              let heading = headingAnnotation else { return }

        if heading.coordinate.latitude != info.coordinate.latitude
            || heading.coordinate.longitude != info.coordinate.longitude {
            heading.coordinate = info.coordinate
        }

        let shouldShow = info.inClusterId == nil
            && info.annotationOnMap
            && (info.coordinate.latitude != 0 || info.coordinate.longitude != 0)

        if shouldShow && !headingOnMap {
            ctx.mapView.addAnnotation(heading)
            headingOnMap = true
        } else if !shouldShow && headingOnMap {
            ctx.mapView.removeAnnotation(heading)
            headingOnMap = false
        }
    }
}
