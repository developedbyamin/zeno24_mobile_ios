import SwiftUI

/// Inbox / circle chat list — mirrors messages_view.dart
struct MessagesView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        NavigationStack {
            List {
                // TODO: ForEach over CirclesStore.circles
            }
            .navigationTitle(AppStrings.Tab.messages)
        }
    }
}
