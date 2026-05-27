import SwiftUI
import UIKit

/// SwiftUI silently disables the `UINavigationController.interactivePopGestureRecognizer`
/// whenever a route hides the back button (`navigationBarBackButtonHidden(true)` /
/// `toolbar(.hidden, for: .navigationBar)`). Re-enabling it keeps Apple's
/// interactive, animated edge-swipe — the screen tracks the finger and snaps
/// to the dismiss/restore position based on translation/velocity. Using the
/// native gesture is important because it also keeps the underlying view
/// rendered during the drag; a SwiftUI offset-based gesture leaves an empty
/// window background behind the swiped screen.
struct InteractivePopGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController { .init() }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            guard let nav = uiViewController.navigationController else { return }
            nav.interactivePopGestureRecognizer?.isEnabled = true
            // Clearing the delegate lets the gesture fire even when the
            // toolbar is hidden — by default UIKit consults the delegate,
            // which says "no back button → no swipe".
            nav.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}

extension View {
    /// Restores the native iOS interactive edge-swipe pop gesture on a
    /// NavigationStack route that hides the system navigation bar.
    func enableInteractivePopGesture() -> some View {
        background(InteractivePopGestureEnabler().frame(width: 0, height: 0))
    }
}
