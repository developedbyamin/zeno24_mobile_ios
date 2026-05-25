import UIKit
import MapKit
import CoreLocation

final class MarkerInfo {

    let view: FlutterMarkerView
    var coordinate: CLLocationCoordinate2D
    let w: CGFloat
    let h: CGFloat

    var annotation: FlutterPointAnnotation? = nil
    var annotationOnMap: Bool = false

    var onScreen: Bool = true
    var justAdded: Bool = true

    var displayName: String = ""
    var avatarImage: UIImage? = nil
    var fallbackColor: UIColor = UIColor(red: 0xF2/255.0, green: 0xF5/255.0, blue: 0xF9/255.0, alpha: 1)
    var activitySinceMs: Int = 0

    var inClusterId: String? = nil

    var clusterAnimStartTime: CFTimeInterval? = nil
    let clusterAnimDuration: CFTimeInterval = 0.25
    var clusterAnimStartX: CGFloat = 0
    var clusterAnimStartY: CGFloat = 0
    var clusterAnimEndX: CGFloat = 0
    var clusterAnimEndY: CGFloat = 0
    var clusterAnimStartAlpha: CGFloat = 1
    var clusterAnimEndAlpha: CGFloat = 1

    var clusterAnimHidesOnEnd: Bool = false

    var displayOffsetX: CGFloat = 0
    var displayOffsetY: CGFloat = 0
    var targetOffsetX: CGFloat = 0
    var targetOffsetY: CGFloat = 0
    var offsetAnimStartTime: CFTimeInterval? = nil
    let offsetAnimDuration: CFTimeInterval = 0.25
    var offsetAnimStartX: CGFloat = 0
    var offsetAnimStartY: CGFloat = 0

    var classifiedOnScreen: Bool = false
    var classifiedIsLeftEdge: Bool = false
    var classifiedEdgeY: CGFloat = 0
    var classifiedScreenX: CGFloat = 0
    var classifiedScreenY: CGFloat = 0

    var classifiedCulled: Bool = false

    var moveAnimStartTime: CFTimeInterval? = nil
    let moveAnimDuration: CFTimeInterval = 1.8
    var moveAnimStartLat: Double = 0
    var moveAnimStartLng: Double = 0
    var moveAnimEndLat: Double = 0
    var moveAnimEndLng: Double = 0

    var returnAnimStartTime: CFTimeInterval? = nil
    let returnAnimDuration: CFTimeInterval = 0.2
    var returnAnimStartX: CGFloat = 0
    var returnAnimStartY: CGFloat = 0
    var returnAnimStartRot: CGFloat = 0
    var returnAnimStartScale: CGFloat = 1
    var liveTargetX: CGFloat = 0
    var liveTargetY: CGFloat = 0

    var snapAnimStartTime: CFTimeInterval? = nil
    let snapAnimDuration: CFTimeInterval = 0.18
    var snapAnimStartX: CGFloat = 0
    var snapAnimStartY: CGFloat = 0
    var snapAnimStartRot: CGFloat = 0
    var snapAnimStartScale: CGFloat = 1
    var snapAnimEndX: CGFloat = 0
    var snapAnimEndY: CGFloat = 0
    var snapAnimEndRot: CGFloat = 0

    var smoothedScreenX: CGFloat = 0
    var smoothedScreenY: CGFloat = 0

    var smoothedInitialized: Bool = false

    var edgePillView: FlutterMarkerView? = nil
    var edgePillW: CGFloat = 0
    var edgePillH: CGFloat = 0
    var edgePillCacheKey: String = ""
    var edgePillShowing: Bool = false

    init(view: FlutterMarkerView, coordinate: CLLocationCoordinate2D, w: CGFloat, h: CGFloat) {
        self.view = view
        self.coordinate = coordinate
        self.w = w
        self.h = h
    }
}
