import Foundation

/// Deep-link handler — mirrors deep_link_provider.dart
@MainActor
@Observable
final class DeepLinkStore {
    var pendingRoute: AppRoute?

    /// Handle a URL like zeno24://join?code=ABC123
    func handle(_ url: URL) {
        guard let host = url.host else { return }
        switch host {
        case "join":
            // TODO: read query, push join sheet
            break
        case "circle":
            // TODO: open circle by id
            break
        default:
            break
        }
    }
}
