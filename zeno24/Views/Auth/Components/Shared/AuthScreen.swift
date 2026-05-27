import SwiftUI

// Hides the system nav bar and re-enables the native interactive pop gesture
// so the screen can be swiped back. SwiftUI silently disables the gesture
// whenever `navigationBarBackButtonHidden(true)` is set, so we restore it
// via the UIKit bridge — this gives Apple's finger-tracking animation and,
// crucially, keeps the underlying view rendered during the drag (a custom
// SwiftUI offset gesture would show an empty white window behind).
struct AuthScreen<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            AuthGradientBackground()
            content()
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .enableInteractivePopGesture()
    }
}
