import Foundation

@MainActor
@Observable
final class DeepLinkStore {
    var pendingInviteCode: String?

    func handle(_ url: URL) {
        if let code = Self.extractInviteCode(from: url) {
            pendingInviteCode = code
        }
    }

    func handle(userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return }
        handle(url)
    }

    func clearPendingInvite() {
        pendingInviteCode = nil
    }

    static func extractInviteCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let items = components.queryItems else { return nil }
        for item in items {
            if item.name == "code" || item.name == "data[code]" {
                let trimmed = item.value?.trimmingCharacters(in: .whitespacesAndNewlines)
                if let value = trimmed, !value.isEmpty { return value }
            }
        }
        return nil
    }
}
