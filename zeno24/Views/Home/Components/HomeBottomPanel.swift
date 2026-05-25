import SwiftUI

struct HomeBottomPanel: View {
    let store: HomeStore
    let members: [MarkerModel]
    var onSheetOffset: ((_ sheetTopY: CGFloat, _ normalized: CGFloat) -> Void)? = nil

    @State private var vm = HomeBottomPanelViewModel()
    @Environment(\.tabBarHeight) private var tabBarHeight

    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let baseY = vm.topOffset(for: vm.detent, height: height)
            let liveY = vm.clampedOffset(baseY + vm.sheetDrag, height: height)
            let visibleCardHeight = max(0, height - liveY - vm.headerHeight)

            let collapsedY = vm.topOffset(for: .collapsed, height: height)
            let expandedY  = vm.topOffset(for: .expanded,  height: height)
            let normalized = height > 0
                ? max(0, min(1, (collapsedY - liveY) / max(1, collapsedY - expandedY)))
                : 0

            sheetContent(cardHeight: visibleCardHeight)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .offset(y: liveY)
                .gesture(unifiedGesture(height: height, cardHeight: visibleCardHeight))
                .onChange(of: liveY) { oldValue, newValue in
                    guard abs(newValue - oldValue) > 0.5 else { return }
                    onSheetOffset?(newValue, normalized)
                }
                .onChange(of: normalized) { oldValue, newValue in
                    guard abs(newValue - oldValue) > 0.01 else { return }
                    onSheetOffset?(liveY, newValue)
                }
                .onAppear {
                    onSheetOffset?(liveY, normalized)
                }
        }
        .background(
            GeometryReader { g in
                Color.clear.task(id: g.safeAreaInsets.bottom) {
                    vm.bottomInset = g.safeAreaInsets.bottom
                }
            }
        )
    }

    // MARK: - Content

    private func sheetContent(cardHeight: CGFloat) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color(hex: 0xD3D5D8))
                    .frame(width: 44, height: 5)
                    .padding(.top, 10)

                Spacer().frame(height: 20)

                HomeNavRow(active: vm.section) { tapped in
                    Haptics.selection()
                    vm.scroll(to: tapped, cardHeight: cardHeight)
                }
                .padding(.horizontal, 10)

                Spacer().frame(height: 10)
            }
            .background(
                GeometryReader { g in
                    Color.clear.preference(key: HeaderHeightKey.self, value: g.size.height)
                }
            )

            HomeSectionCard(
                scrollOffset: vm.listOffset,
                visibleHeight: cardHeight,
                contentHeight: Binding(
                    get: { vm.contentHeight },
                    set: { vm.contentHeight = $0 }
                )
            ) {
                unifiedScrollContent
            }
            .padding(.horizontal, 10)
        }
        .onPreferenceChange(HeaderHeightKey.self) { h in
            if h > 0 && abs(h - vm.headerHeight) > 0.5 {
                vm.headerHeight = h
            }
        }
        .frame(maxWidth: .infinity)
        .background { PanelBackground() }
        .compositingGroup()
        .mask {
            UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: 30, topTrailing: 30)
            )
            .fill(Color.black)
        }
        .contentShape(Rectangle())
    }

    private var unifiedScrollContent: some View {
        VStack(spacing: 0) {
            anchored(.members) { HomeMembersContent(members: members) }
            anchored(.places)  { HomePlacesContent() }
            anchored(.pets)    { HomePetsContent() }
            anchored(.alerts)  { HomeAlertsContent() }
            Spacer().frame(height: tabBarHeight + 16)
        }
        .coordinateSpace(name: Self.scrollSpace)
        .onPreferenceChange(SectionAnchorKey.self) { anchors in
            let hasChanges = anchors.contains { key, value in
                guard let existing = vm.sectionAnchors[key] else { return true }
                return abs(existing - value) > 0.5
            }
            guard hasChanges else { return }
            let merged = vm.sectionAnchors.merging(anchors) { _, new in new }
            if merged != vm.sectionAnchors { vm.sectionAnchors = merged }
        }
    }

    @ViewBuilder
    private func anchored<Content: View>(
        _ tab: HomeBottomSection,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: SectionAnchorKey.self,
                        value: [tab: proxy.frame(in: .named(Self.scrollSpace)).minY]
                    )
                }
            )
    }

    // MARK: - Gesture

    private func unifiedGesture(height: CGFloat, cardHeight: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let delta = value.translation.height - vm.lastTranslation
                vm.lastTranslation = value.translation.height
                let previousListOffset = vm.listOffset
                vm.dispatchDelta(delta, cardHeight: cardHeight)
                if vm.listOffset != previousListOffset {
                    vm.updateInferredSection()
                }
            }
            .onEnded { value in
                let remaining = value.predictedEndTranslation.height - value.translation.height
                vm.finishDrag(predictedRemaining: remaining, height: height, cardHeight: cardHeight)
            }
    }

    // MARK: - Constants

    private static let scrollSpace = "HomeSheetScroll"
}

// MARK: - Stable background

private struct PanelBackground: View {
    var body: some View {
        ZStack {
            Rectangle().fill(.thinMaterial)
            LinearGradient(
                colors: [
                    Color(hex: 0xF8F7FF).opacity(0.7),
                    Color(hex: 0xF6D2FF).opacity(0.7),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - Preference keys

private struct HeaderHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct SectionAnchorKey: PreferenceKey {
    static let defaultValue: [HomeBottomSection: CGFloat] = [:]
    static func reduce(value: inout [HomeBottomSection: CGFloat],
                       nextValue: () -> [HomeBottomSection: CGFloat]) {
        value.merge(nextValue()) { _, new in new }
    }
}

// MARK: - Models

enum HomeSheetDetent: Hashable {
    case collapsed, halfExpanded, expanded
}

enum HomeBottomSection: String, CaseIterable, Hashable, Identifiable {
    case members, places, pets, alerts
    var id: String { rawValue }

    var title: String {
        switch self {
        case .members: return AppStrings.Home.members
        case .places:  return AppStrings.Home.places
        case .pets:    return AppStrings.Home.pets
        case .alerts:  return AppStrings.Home.alerts
        }
    }

    var iconAsset: String {
        switch self {
        case .members: return AppVectors.members
        case .places:  return AppVectors.earth
        case .pets:    return AppVectors.pets
        case .alerts:  return AppVectors.alerts
        }
    }
}
