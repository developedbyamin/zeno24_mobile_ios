import Foundation
import CoreLocation

/// Home / map screen state — mirrors home_action_controller.dart + map_type_provider.dart
@MainActor
@Observable
final class HomeStore {
    enum MapType: String, CaseIterable, Identifiable {
        case standard, satellite, hybrid
        var id: String { rawValue }
    }

    var mapType: MapType = .standard
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
