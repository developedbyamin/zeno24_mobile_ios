import SwiftUI

/// Edge-swipe gesture that triggers `onSwipeBack` when the user pulls
/// from the leading edge — mirrors the iOS native interactive pop that
/// SwiftUI silently disables whenever `navigationBarBackButtonHidden(true)`
/// is set. Apply via `.swipeBackGesture { ... }` on the screen root.
struct SwipeBackGesture: ViewModifier {
    var onSwipeBack: () -> Void
    var edgeWidth: CGFloat = 24       // hit area from the leading edge
    var minimumDistance: CGFloat = 60 // distance required to trigger pop

    @State private var startedFromEdge = false

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        if !startedFromEdge && value.startLocation.x <= edgeWidth {
                            startedFromEdge = true
                        }
                    }
                    .onEnded { value in
                        defer { startedFromEdge = false }
                        guard startedFromEdge,
                              value.translation.width > minimumDistance,
                              abs(value.translation.height) < 80
                        else { return }
                        onSwipeBack()
                    }
            )
    }
}

extension View {
    /// Recreates the iOS interactive pop gesture on screens that hide the
    /// native back button. Call once per screen, passing the dismiss action.
    func swipeBackGesture(_ onSwipeBack: @escaping () -> Void) -> some View {
        modifier(SwipeBackGesture(onSwipeBack: onSwipeBack))
    }
}
