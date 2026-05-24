import SwiftUI

/// Top row — Figma 1829:2776:
///   • Back button (36×36) absolutely positioned at the leading edge
///   • Animated icon (81×81) centered horizontally
///   • Both share the same baseline (top of the gradient frame + safe area).
struct AuthHeader<Icon: View>: View {
    let isVisible: Bool
    var canGoBack: Bool = true
    var onBack: () -> Void = {}
    @ViewBuilder var icon: () -> Icon

    var body: some View {
        ZStack {
            icon()

            if canGoBack {
                HStack {
                    AuthBackButton(action: onBack)
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(height: 81)
    }
}
