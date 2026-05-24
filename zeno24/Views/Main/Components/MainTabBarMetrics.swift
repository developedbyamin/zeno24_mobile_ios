import SwiftUI

/// Live measurement of the custom tab bar so children (e.g. the home
/// bottom sheet) can reserve the matching bottom inset. The bar attaches
/// `reportTabBarHeight()` to its background; `MainView` reads it and
/// pushes the value down through `\.tabBarHeight`.
struct TabBarHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct TabBarHeightEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var tabBarHeight: CGFloat {
        get { self[TabBarHeightEnvironmentKey.self] }
        set { self[TabBarHeightEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// Attached to the tab bar so its frame height is reported up the
    /// view tree as `TabBarHeightPreferenceKey`.
    func reportTabBarHeight() -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(
                    key: TabBarHeightPreferenceKey.self,
                    value: proxy.size.height
                )
            }
        )
    }
}
