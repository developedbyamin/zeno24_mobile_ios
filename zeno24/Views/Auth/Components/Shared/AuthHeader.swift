import SwiftUI

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
