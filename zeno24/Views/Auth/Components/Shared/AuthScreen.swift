import SwiftUI

// Adds a leading-edge swipeBackGesture so the screen can be dismissed the way
// iOS users expect — SwiftUI disables the native one whenever
// `navigationBarBackButtonHidden(true)` is set.
struct AuthScreen<Content: View>: View {
    @Environment(AuthStore.self) private var auth
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            AuthGradientBackground()
            content()
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .swipeBackGesture { auth.goBack() }
    }
}
