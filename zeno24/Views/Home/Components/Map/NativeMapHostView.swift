import SwiftUI
import UIKit

struct NativeMapHostView: UIViewRepresentable {

    let markers: [MarkerModel]

    var selfAvatarUrl: String? = nil

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
