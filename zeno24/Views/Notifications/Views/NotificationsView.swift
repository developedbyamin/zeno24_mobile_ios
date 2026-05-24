import SwiftUI

/// Notifications inbox — mirrors notifications_view.dart
struct NotificationsView: View {
    var body: some View {
        NavigationStack {
            List {
                // TODO: notification rows
            }
            .navigationTitle(AppStrings.Tab.notifications)
        }
    }
}
