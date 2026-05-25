import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.openCirclePicker) private var openCirclePicker
    @Environment(CirclesStore.self) private var circles
    @Environment(PremiumStore.self) private var premium
    @State private var home = HomeStore()
    @State private var markers = MarkersStore()
    @State private var mapType: HomeMapType = .auto
    @State private var showMapTypePicker = false
    @State private var sheetTopY: CGFloat = 0
    @State private var normalizedSheetOffset: CGFloat = 0
    
    private var topBarOpacity: CGFloat {
        if normalizedSheetOffset <= 0.5 {
            return 1.0
        } else {
            return max(0, 1.0 - (normalizedSheetOffset - 0.5) * 2)
        }
    }

    private var topBarScale: CGFloat {
        if normalizedSheetOffset <= 0.5 {
            return 1.0
        } else {
            return 1.0 + (normalizedSheetOffset - 0.5) * 0.3
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            NativeMapHostView(
                markers: markers.markers,
                mapType: mapTypeKey(for: mapType)
            )
            .ignoresSafeArea()

            HomeTopBar(
                circleTitle: circles.selectedCircle?.name ?? AppStrings.Home.panelTitle,
                opacity: topBarOpacity,
                scale: topBarScale,
                onSettings:     { router.push(.settings) },
                onCircle:       { openCirclePicker() },
                onNotification: { router.push(.notifications) },
                onChat:         { router.push(.messages) }
            )

            HomeSideActions(
                sheetTopY: sheetTopY,
                normalizedOffset: normalizedSheetOffset,
                onMapType: { showMapTypePicker = true },
                onZoomSelf: { }
            )

            HomeBottomPanel(store: home, members: markers.markers) { topY, normalized in
                sheetTopY = topY
                normalizedSheetOffset = normalized
            }

            if showMapTypePicker {
                HomeMapTypePicker(isPresented: $showMapTypePicker, selected: $mapType)
                    .zIndex(999)
            }
        }
        .task { markers.startSyncing() }
        .onDisappear { markers.stopSyncing() }
        .onAppear {
            // Surface the premium upsell on first home mount (1:1 with the
            // Flutter `addPostFrameCallback` on home_view.dart).
            premium.presentOnFirstLaunchIfNeeded()
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
