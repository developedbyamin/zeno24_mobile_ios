import Foundation
import CoreLocation

@MainActor
@Observable
final class HomeStore {
    var selectedMarkerId: String?
    var cameraTarget: CLLocationCoordinate2D?
    var isPanelExpanded: Bool = false

    func centerOn(_ coordinate: CLLocationCoordinate2D) {
        cameraTarget = coordinate
    }

    func selectMarker(_ id: String?) {
        selectedMarkerId = id
    }
}
