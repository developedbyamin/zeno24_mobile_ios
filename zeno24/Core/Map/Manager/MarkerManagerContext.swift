import UIKit
import MapKit

final class MarkerManagerContext {
    let mapView: MKMapView
    let overlay: UIView

    let registry = MarkerRegistry()
    let edgeResolver = EdgeOverlapResolver()

    var clusters: [String: ClusterEntry] = [:]

    var markerToCluster: [String: String] = [:]

    var clusterBitmapCache: [String: UIImage] = [:]

    var needsLayout: Bool = false

    var batchMode: Bool = false

    var lastLayoutTime: CFTimeInterval = 0

    var isCameraMoving: Bool = false

    init(mapView: MKMapView, overlay: UIView) {
        self.mapView = mapView
        self.overlay = overlay
    }

    func dp(_ value: CGFloat) -> CGFloat { value }
}
