import UIKit
import CoreLocation

final class ClusterEntry {
    let id: String
    var annotation: FlutterClusterAnnotation? = nil
    var memberIds: [String]
    var centerLat: Double
    var centerLng: Double

    var classifiedScreenX: CGFloat = 0
    var classifiedScreenY: CGFloat = 0
    var classifiedCulled: Bool = false

    var formAnimStartTime: CFTimeInterval? = nil
    let formAnimDuration: CFTimeInterval = 0.18

    var splitAnimStartTime: CFTimeInterval? = nil
    let splitAnimDuration: CFTimeInterval = 0.18
    var pendingRemove: Bool = false
    var splitOriginX: CGFloat = 0
    var splitOriginY: CGFloat = 0

    var edgePillView: FlutterMarkerView? = nil
    var edgePillW: CGFloat = 0
    var edgePillH: CGFloat = 0
    var edgePillCacheKey: String = ""
    var edgePillShowing: Bool = false

    var onScreen: Bool = true
    var justAdded: Bool = true

    init(
        id: String,
        memberIds: [String],
        centerLat: Double,
        centerLng: Double
    ) {
        self.id = id
        self.memberIds = memberIds
        self.centerLat = centerLat
        self.centerLng = centerLng
    }
}
