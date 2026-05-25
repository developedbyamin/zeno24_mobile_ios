import SwiftUI

/// Recreates the iOS interactive pop gesture. SwiftUI silently
/// disables it whenever `navigationBarBackButtonHidden(true)` is set,
/// so screens that hide the native back button need this manually.
struct SwipeBackGesture: ViewModifier {
    var onSwipeBack: () -> Void
    var edgeWidth: CGFloat = 24
    var minimumDistance: CGFloat = 60

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
    func swipeBackGesture(_ onSwipeBack: @escaping () -> Void) -> some View {
        modifier(SwipeBackGesture(onSwipeBack: onSwipeBack))
    }
}
