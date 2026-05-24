import Foundation
import CoreLocation

/// Native overlay routing on top of the map — mirrors native_route_overlay provider folder
@MainActor
@Observable
final class NativeRouteOverlayStore {
    var routePolyline: [CLLocationCoordinate2D] = []
    var isVisible: Bool = false

    func show(_ polyline: [CLLocationCoordinate2D]) {
        routePolyline = polyline
        isVisible = true
    }

    func hide() {
        routePolyline = []
        isVisible = false
    }
}
