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
///
/// As a side effect we dismiss the keyboard as soon as the swipe begins so
/// the screen sliding in from the left isn't pushed up by a still-active
/// keyboard frame (a textfield on the *previous* screen used to "jump" up
/// during the drag because UIKit kept reporting the keyboard as visible
/// until the pop animation completed).
struct InteractivePopGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController { .init() }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            guard let nav = uiViewController.navigationController,
                  let recognizer = nav.interactivePopGestureRecognizer
            else { return }
            recognizer.isEnabled = true
            // Clearing the delegate lets the gesture fire even when the
            // toolbar is hidden — by default UIKit consults the delegate,
            // which says "no back button → no swipe".
            recognizer.delegate = nil

            // Idempotent: only attach the dismiss-keyboard target once. The
            // gesture recognizer is reused across pushes/pops, so we tag the
            // recognizer with the coordinator pointer to avoid double-add.
            if !context.coordinator.isAttached(to: recognizer) {
                recognizer.addTarget(
                    context.coordinator,
                    action: #selector(Coordinator.handleSwipeBack(_:))
                )
                context.coordinator.markAttached(to: recognizer)
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject {
        // Weak-box list so dealloc-ing recognizers don't keep us pinned.
        private var attached = NSHashTable<UIGestureRecognizer>.weakObjects()

        func isAttached(to recognizer: UIGestureRecognizer) -> Bool {
            attached.contains(recognizer)
        }

        func markAttached(to recognizer: UIGestureRecognizer) {
            attached.add(recognizer)
        }

        @objc func handleSwipeBack(_ recognizer: UIGestureRecognizer) {
            // Fire keyboard dismissal as soon as the gesture starts —
            // `endEditing` is a no-op if nothing is focused so it's safe
            // to call unconditionally. Sending it to the active window
            // resigns first responder for every textfield in the hierarchy.
            guard recognizer.state == .began else { return }
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .endEditing(true)
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
