import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.openCirclePicker) private var openCirclePicker
    @Environment(CirclesStore.self) private var circles
    @Environment(MarkersStore.self) private var markers
    @State private var home = HomeStore()
    @State private var sheetMetrics = HomeSheetMetrics()
    @State private var mapType: HomeMapType = .auto
    @State private var showMapTypePicker = false

    var body: some View {
        ZStack(alignment: .top) {
            NativeMapHostView(
                markers: markers.markers,
                mapType: mapTypeKey(for: mapType)
            )
            .ignoresSafeArea()

            HomeTopBar(
                circleTitle: circles.selectedCircle?.name ?? AppStrings.Home.panelTitle,
                metrics: sheetMetrics,
                onSettings:     { router.push(.settings) },
                onCircle:       { openCirclePicker() },
                onNotification: { router.push(.notifications) },
                onChat:         { router.push(.messages) }
            )

            HomeSideActions(
                metrics: sheetMetrics,
                onMapType: { showMapTypePicker = true },
                onZoomSelf: { }
            )

            HomeBottomPanel(
                store: home,
                members: markers.markers,
                metrics: sheetMetrics
            )

            if showMapTypePicker {
                HomeMapTypePicker(isPresented: $showMapTypePicker, selected: $mapType)
                    .zIndex(999)
            }
        }
        .navigationTitle(AppStrings.Tab.home)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func mapTypeKey(for type: HomeMapType) -> String {
        switch type {
        case .auto:      return "default"
        case .street:    return "default"
        case .satellite: return "satellite"
        }
    }
}
