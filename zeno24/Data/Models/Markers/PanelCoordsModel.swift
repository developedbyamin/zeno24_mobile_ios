import Foundation
import CoreLocation

/// Navimax coordinates — `panel_coords_model.dart`.
struct PanelCoordsModel: Decodable, Hashable {
    let lat: Double?
    let lng: Double?

    var coordinate: CLLocationCoordinate2D? {
        guard let lat, let lng else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
