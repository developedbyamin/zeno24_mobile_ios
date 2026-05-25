import UIKit
import MapKit
import CoreLocation

/// MKMapView-based native map host. Ported 1:1 from the Flutter project's
/// `ios/Runner/Map/NativeMapView.swift` — Flutter `PlatformView` conformance
/// stripped so it can be embedded directly via `UIViewRepresentable`.
class NativeMapView: NSObject, MKMapViewDelegate,
    CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    private let container = UIView()
    private let mapView = MKMapView()
    private let overlay = TapDetectingOverlay()
    private let locationManager = CLLocationManager()
    private(set) var flutterMarkerManager: FlutterMarkerManager?

    private var displayLink: CADisplayLink?
    private var stopLinkTimer: Timer?

    var onClusterTap: (([String]) -> Void)?
    /// İstifadəçi xəritədə pan/pinch/double-tap etdikdə bir dəfə tetiklənir.
    /// Bottom sheet-i collapsed state-ə çəkmək üçün istifadə olunur.
    var onUserMapGesture: (() -> Void)?

    override init() {
        super.init()

        container.frame = .zero

        mapView.frame = container.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        overlay.frame = container.bounds
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.backgroundColor = .clear

        container.addSubview(mapView)
        container.addSubview(overlay)

        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.showsCompass = false
        mapView.isPitchEnabled = false
        // Map həmişə light mode-da render olunsun — system dark mode-a girəndə
        // MKMapView avtomatik dark theme tətbiq edir, biz bunu söndürürük
        // (brand tile-ları yalnız light variant üçün dizayn olunub).
        mapView.overrideUserInterfaceStyle = .light
        // Marker overlay layer-i də eyni — popup-larda dark tint qarşısını
        // alırıq (label rəngləri light bg-yə uyğun seçilib).
        overlay.overrideUserInterfaceStyle = .light
        container.overrideUserInterfaceStyle = .light

        let mgr = FlutterMarkerManager(mapView: mapView, overlay: overlay)
        flutterMarkerManager = mgr
        overlay.markerManager = mgr

        let link = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        if #available(iOS 15.0, *) {
            link.preferredFrameRateRange = CAFrameRateRange(minimum: 80, maximum: 120, preferred: 120)
        }
        link.isPaused = true
        link.add(to: .main, forMode: .common)
        displayLink = link
        mgr.onScheduleNextFrame = { [weak self] in self?.resumeDisplayLink() }

        mgr.onClusterTap = { [weak self] memberIds in
            self?.zoomToCluster(memberIds: memberIds)
            self?.onClusterTap?(memberIds)
        }

        mgr.onEdgePillTap = { [weak self] memberIds in
            self?.zoomToCluster(memberIds: memberIds)
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.headingFilter = 2

        installUserGestureRecognizers()

        centerMapDefault()
    }

    /// MKMapView pan/pinch/double-tap-ı **paralel** olaraq qəbul edən
    /// recognizer-lər — map-in öz scroll-zoom-unu sındırmırlar.
    private func installUserGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleUserGesture(_:)))
        pan.delegate = self
        pan.cancelsTouchesInView = false
        mapView.addGestureRecognizer(pan)

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handleUserGesture(_:)))
        pinch.delegate = self
        pinch.cancelsTouchesInView = false
        mapView.addGestureRecognizer(pinch)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleUserGesture(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        doubleTap.cancelsTouchesInView = false
        mapView.addGestureRecognizer(doubleTap)
    }

    @objc private func handleUserGesture(_ rec: UIGestureRecognizer) {
        // Pan/pinch üçün .began (long-press əvəzi); tap üçün .ended.
        if rec.state == .began || (rec is UITapGestureRecognizer && rec.state == .ended) {
            onUserMapGesture?()
        }
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
    ) -> Bool {
        return true
    }

    func view() -> UIView { container }

    /// Public accessor for the SwiftUI host — same view returned by `view()`,
    /// kept under the legacy name for parity with the Flutter port.
    var containerView: UIView { container }

    @objc private func displayLinkTick() {
        flutterMarkerManager?.updateAllMarkerPositions()
    }

    private func resumeDisplayLink() {
        stopLinkTimer?.invalidate()
        stopLinkTimer = nil
        displayLink?.isPaused = false
    }

    private func scheduleDisplayLinkStop(after delay: TimeInterval = 0.5) {
        stopLinkTimer?.invalidate()
        stopLinkTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.displayLink?.isPaused = true
        }
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        flutterMarkerManager?.setCameraMoving(true)
        resumeDisplayLink()
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        flutterMarkerManager?.setCameraMoving(false)
        flutterMarkerManager?.recomputeClusters()
        flutterMarkerManager?.updateAllMarkerPositions()
        scheduleDisplayLinkStop()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let heading = annotation as? FlutterHeadingAnnotation {
            let view: FlutterHeadingAnnotationView
            if let reused = mapView.dequeueReusableAnnotationView(withIdentifier: FlutterHeadingAnnotationView.reuseId) as? FlutterHeadingAnnotationView {
                view = reused
            } else {
                view = FlutterHeadingAnnotationView(annotation: heading, reuseIdentifier: FlutterHeadingAnnotationView.reuseId)
            }
            view.bind(heading)
            return view
        }
        if let cluster = annotation as? FlutterClusterAnnotation {
            let view: FlutterClusterAnnotationView
            if let reused = mapView.dequeueReusableAnnotationView(withIdentifier: FlutterClusterAnnotationView.reuseId) as? FlutterClusterAnnotationView {
                view = reused
            } else {
                view = FlutterClusterAnnotationView(annotation: cluster, reuseIdentifier: FlutterClusterAnnotationView.reuseId)
            }
            view.bind(cluster)
            return view
        }
        if let pin = annotation as? FlutterPointAnnotation {
            let view: FlutterAnnotationView
            if let reused = mapView.dequeueReusableAnnotationView(withIdentifier: FlutterAnnotationView.reuseId) as? FlutterAnnotationView {
                view = reused
            } else {
                view = FlutterAnnotationView(annotation: pin, reuseIdentifier: FlutterAnnotationView.reuseId)
            }
            view.bind(pin)
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cluster = view.annotation as? FlutterClusterAnnotation {
            mapView.deselectAnnotation(cluster, animated: false)
            zoomToCluster(memberIds: cluster.memberIds)
            flutterMarkerManager?.onClusterTap?(cluster.memberIds)
            return
        }
        guard let pin = view.annotation as? FlutterPointAnnotation else { return }
        if pin.markerId == FlutterMarkerManager.SELF_MARKER_ID {
            mapView.deselectAnnotation(pin, animated: false)
            return
        }
        flutterMarkerManager?.onMarkerTap?(pin.markerId)
        mapView.deselectAnnotation(pin, animated: false)
    }

    private var hasCenteredOnSelf = false

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }

        if !hasCenteredOnSelf {
            hasCenteredOnSelf = true
            let region = MKCoordinateRegion(
                center: loc.coordinate,
                latitudinalMeters: 2_000,
                longitudinalMeters: 2_000
            )
            mapView.setRegion(region, animated: true)
        }

        flutterMarkerManager?.updateSelfLocation(
            lat: loc.coordinate.latitude, lng: loc.coordinate.longitude
        )
        resumeDisplayLink()
        scheduleDisplayLinkStop(after: 1.0)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard newHeading.headingAccuracy >= 0 else { return }
        flutterMarkerManager?.updateSelfHeading(degrees: newHeading.trueHeading)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("[NativeMapView] location error: \(error.localizedDescription)")
    }

    private func centerMapDefault() {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.4093, longitude: 49.8671),
            latitudinalMeters: 5_000, longitudinalMeters: 5_000
        )
        mapView.setRegion(region, animated: false)
    }

    func addMarker(
        id: String,
        lat: Double,
        lng: Double,
        avatarUrl: String?,
        displayName: String,
        activityCode: String,
        speedKmh: Double,
        activitySinceMs: Int,
        fallbackColorHex: Int
    ) {
        guard let mgr = flutterMarkerManager else { return }
        let fallbackColor = MarkerRenderer.color(fromARGB: fallbackColorHex)
        let pinSize = CGSize(width: MarkerRenderer.pinWidth, height: MarkerRenderer.pinHeight)

        if !mgr.hasMarker(id: id) {
            let placeholder = MarkerRenderer.renderPin(
                avatar: nil, displayName: displayName, activity: activityCode,
                speedKmh: speedKmh, activitySinceMs: activitySinceMs,
                fallbackColor: fallbackColor
            )
            let view = FlutterMarkerView(frame: .zero)
            view.setImage(placeholder, size: pinSize)
            mgr.addMarkerView(
                id: id, lat: lat, lng: lng, view: view,
                widthDp: pinSize.width, heightDp: pinSize.height,
                displayName: displayName,
                fallbackColor: fallbackColor,
                activitySinceMs: activitySinceMs
            )
        } else {
            mgr.updateFlutterMarker(id: id, lat: lat, lng: lng)
        }

        resumeDisplayLink()
        scheduleDisplayLinkStop()

        if let url = avatarUrl, !url.isEmpty {
            MarkerRenderer.loadImage(url: url) { [weak self] image in
                guard let image = image, let mgr = self?.flutterMarkerManager else { return }
                let final_ = MarkerRenderer.renderPin(
                    avatar: image, displayName: displayName, activity: activityCode,
                    speedKmh: speedKmh, activitySinceMs: activitySinceMs,
                    fallbackColor: fallbackColor
                )
                mgr.setMarkerImage(id: id, image: final_)
                mgr.setMarkerAvatar(id: id, image: image)
                self?.flutterMarkerManager?.updateAllMarkerPositions()
            }
        }
    }

    /// Strongly-typed bulk upsert. Replaces the dict-based bridge that
    /// existed for Flutter `MethodChannel` compatibility.
    func setMarkers(_ markers: [MarkerModel], fallbackColorHex: Int = 0xFFFF5F03) {
        guard let mgr = flutterMarkerManager else { return }
        mgr.beginBatch()

        let incomingIds = Set(markers.map(\.userId))
        let toRemove = mgr.allMarkerIds().filter {
            !incomingIds.contains($0) && $0 != FlutterMarkerManager.SELF_MARKER_ID
        }
        for id in toRemove { mgr.removeMarker(id: id) }

        let fallbackColor = MarkerRenderer.color(fromARGB: fallbackColorHex)
        for marker in markers {
            upsertMarker(marker, manager: mgr, fallbackColor: fallbackColor)
        }

        mgr.endBatch()
        resumeDisplayLink()
        scheduleDisplayLinkStop()
    }

    private func upsertMarker(
        _ marker: MarkerModel,
        manager mgr: FlutterMarkerManager,
        fallbackColor: UIColor
    ) {
        let id = marker.userId
        guard !id.isEmpty else { return }

        if mgr.hasMarker(id: id) {
            mgr.updateFlutterMarker(id: id, lat: marker.lat, lng: marker.lng)
            return
        }

        let activityCode = marker.activity.rawValue
        let pinSize = CGSize(width: MarkerRenderer.pinWidth, height: MarkerRenderer.pinHeight)
        let placeholder = MarkerRenderer.renderPin(
            avatar: nil,
            displayName: marker.displayName,
            activity: activityCode,
            speedKmh: marker.speedKmh,
            activitySinceMs: marker.activitySinceMs,
            fallbackColor: fallbackColor
        )
        let view = FlutterMarkerView(frame: .zero)
        view.setImage(placeholder, size: pinSize)
        mgr.addMarkerView(
            id: id, lat: marker.lat, lng: marker.lng, view: view,
            widthDp: pinSize.width, heightDp: pinSize.height,
            displayName: marker.displayName,
            fallbackColor: fallbackColor,
            activitySinceMs: marker.activitySinceMs
        )

        guard !marker.avatarUrl.isEmpty else { return }
        MarkerRenderer.loadImage(url: marker.avatarUrl) { [weak self] image in
            guard let image, let mgr = self?.flutterMarkerManager else { return }
            let final_ = MarkerRenderer.renderPin(
                avatar: image,
                displayName: marker.displayName,
                activity: activityCode,
                speedKmh: marker.speedKmh,
                activitySinceMs: marker.activitySinceMs,
                fallbackColor: fallbackColor
            )
            mgr.setMarkerImage(id: id, image: final_)
            mgr.setMarkerAvatar(id: id, image: image)
        }
    }

    func updateFlutterMarker(id: String, lat: Double, lng: Double) {
        flutterMarkerManager?.updateFlutterMarker(id: id, lat: lat, lng: lng)
        resumeDisplayLink()
        scheduleDisplayLinkStop(after: 2.0)
    }

    func setSelfMarker(avatarUrl: String) {
        MarkerRenderer.loadImage(url: avatarUrl) { [weak self] image in
            guard let image = image else { return }
            let rendered = MarkerRenderer.renderSelf(avatar: image)
            let size = CGSize(width: MarkerRenderer.selfWidth, height: MarkerRenderer.selfHeight)
            self?.flutterMarkerManager?.setSelfMarkerImage(rendered, size: size)
        }
    }

    func startLocationTracking() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
        locationManager.startUpdatingLocation()
        if CLLocationManager.headingAvailable() { locationManager.startUpdatingHeading() }
    }

    func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }

    func refreshMap() { locationManager.requestLocation() }

    func setEdgePillSafeTop(_ y: Float) {
        flutterMarkerManager?.setEdgePillSafeTop(y)
    }

    func setEdgePillSafeBottom(_ y: Float) {
        flutterMarkerManager?.setEdgePillSafeBottom(y)
    }

    func setMapType(_ type: String) {
        switch type {
        case "street":    mapView.mapType = .mutedStandard
        case "satellite": mapView.mapType = .hybrid
        default:          mapView.mapType = .standard
        }
    }

    func zoomToUser(id: String, zoomMeters: Double = 800) {
        guard let mgr = flutterMarkerManager,
              let coord = mgr.coordinate(forMarkerId: id) else { return }
        let region = MKCoordinateRegion(
            center: coord, latitudinalMeters: zoomMeters, longitudinalMeters: zoomMeters
        )
        mapView.setRegion(region, animated: true)
    }

    func zoomToSelf(zoomMeters: Double = 800) {
        guard let coord = flutterMarkerManager?.currentSelfCoordinate else { return }
        let region = MKCoordinateRegion(
            center: coord, latitudinalMeters: zoomMeters, longitudinalMeters: zoomMeters
        )
        mapView.setRegion(region, animated: true)
    }

    private func zoomToCluster(memberIds: [String]) {
        guard let mgr = flutterMarkerManager else { return }
        let coords = memberIds.compactMap { mgr.coordinate(forMarkerId: $0) }
        guard !coords.isEmpty else { return }

        var minLat = coords[0].latitude
        var maxLat = coords[0].latitude
        var minLng = coords[0].longitude
        var maxLng = coords[0].longitude
        for c in coords {
            minLat = min(minLat, c.latitude)
            maxLat = max(maxLat, c.latitude)
            minLng = min(minLng, c.longitude)
            maxLng = max(maxLng, c.longitude)
        }
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLng + maxLng) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.4, 0.0005),
            longitudeDelta: max((maxLng - minLng) * 1.4, 0.0005)
        )
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }

    func setOnMarkerTap(_ handler: @escaping (String) -> Void) {
        flutterMarkerManager?.onMarkerTap = handler
    }

    deinit {
        displayLink?.invalidate()
        stopLinkTimer?.invalidate()
    }
}

class TapDetectingOverlay: UIView {
    weak var markerManager: FlutterMarkerManager?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOverlayTap(_:)))
        addGestureRecognizer(tap)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let mgr = markerManager else { return nil }
        return mgr.findHitAt(point) != nil ? self : nil
    }

    @objc private func handleOverlayTap(_ rec: UITapGestureRecognizer) {
        let pt = rec.location(in: self)
        guard let result = markerManager?.findHitAt(pt) else { return }
        switch result {
        case .marker(let id):
            markerManager?.onMarkerTap?(id)
        case .cluster(let ids):
            markerManager?.onClusterTap?(ids)
        case .edgePill(let ids):
            markerManager?.onEdgePillTap?(ids)
        }
    }
}
