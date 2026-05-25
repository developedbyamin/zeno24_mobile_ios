import SwiftUI

extension EnvironmentValues {
    /// Measured height of the floating `MainTabBar` (content + bottom safe
    /// area). Tab views use this to lift bottom-anchored UI like the circle
    /// pill above the bar — push views see `0` because the bar isn't shown.
    @Entry var tabBarHeight: CGFloat = 0

    /// `true` for the tab whose content is currently visible. Used to gate
    /// elements that own system-level popovers (Menu, ContextMenu) so they
    /// unmount when the user switches tabs — otherwise the popover lingers
    /// on top of the new tab because all five tabs stay alive in the ZStack.
    @Entry var isTabActive: Bool = true
}
