import SwiftUI

/// Map-based home screen — hosts the UIKit `NativeMapView` ported from
/// the Flutter project. Mirrors `lib/src/presentation/home/views/ios_views_home_view.dart`
/// minus the Flutter platform channels.
struct HomeView: View {
    @State private var home = HomeStore()
    @State private var markers = MarkersStore()

    var body: some View {
        ZStack {
            NativeMapHostView(
                markers: markers.markers,
                mapType: mapTypeKey(for: home.mapType)
            )
            .ignoresSafeArea()
            HomeBottomPanel(store: home, members: markers.markers)
        }
        .task { markers.startSyncing() }
        .onDisappear { markers.stopSyncing() }
    }

    private func mapTypeKey(for type: HomeStore.MapType) -> String {
        switch type {
        case .standard:  return "default"
        case .satellite: return "satellite"
        case .hybrid:    return "satellite"
        }
    }
}
