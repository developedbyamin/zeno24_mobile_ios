import SwiftUI
import UIKit

/// SwiftUI host for the UIKit-based `NativeMapView`. Forwards the active
/// marker list and self-marker config; updates the map in `updateUIView`
/// without rebuilding the underlying `MKMapView`.
struct NativeMapHostView: UIViewRepresentable {

    /// Live circle members rendered on the map.
    let markers: [MarkerModel]

    /// Optional self-marker avatar URL — drives the heading dot tile.
    var selfAvatarUrl: String? = nil

    /// One of `"default" | "street" | "satellite"`.
    var mapType: String = "default"

    var onMarkerTap: ((String) -> Void)? = nil
    var onUserMapGesture: (() -> Void)? = nil

    final class Coordinator {
        let map: NativeMapView
        var lastSelfAvatarUrl: String?
        var lastMapType: String?

        init() {
            self.map = NativeMapView()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIView {
        let map = context.coordinator.map
        map.startLocationTracking()
        map.onUserMapGesture = onUserMapGesture
        map.setOnMarkerTap { id in onMarkerTap?(id) }
        return map.containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        let map = context.coordinator.map

        if context.coordinator.lastMapType != mapType {
            map.setMapType(mapType)
            context.coordinator.lastMapType = mapType
        }

        if let url = selfAvatarUrl,
           !url.isEmpty,
           context.coordinator.lastSelfAvatarUrl != url {
            map.setSelfMarker(avatarUrl: url)
            context.coordinator.lastSelfAvatarUrl = url
        }

        map.setMarkers(markers)
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        coordinator.map.stopLocationTracking()
    }
}
