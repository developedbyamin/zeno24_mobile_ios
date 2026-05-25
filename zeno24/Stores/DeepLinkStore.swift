import Foundation

@MainActor
@Observable
final class DeepLinkStore {
    var pendingRoute: AppRoute?

    func handle(_ url: URL) {
        guard let host = url.host else { return }
        switch host {
        case "join":
            break
        case "circle":
            break
        default:
            break
        }
    }
}
