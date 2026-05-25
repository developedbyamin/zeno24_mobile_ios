import Foundation

final class MarkersRepository {
    private let service: MarkersService

    init(service: MarkersService) {
        self.service = service
    }

    func fetchMarkers() async throws -> [MarkerModel] {
        let response = try await service.fetchSyncList()
        let items = response.data ?? []
        return items.map(Self.toDomain)
    }

    // MARK: - Mapping

    private static func toDomain(_ o: PanelObjectModel) -> MarkerModel {
        let speed = o.speedVal ?? 0
        let action = o.lastHistory?.action?.lowercased()
        return MarkerModel(
            userId: (o.id ?? "").trimmingCharacters(in: .whitespaces),
            displayName: pickName(o),
            avatarUrl: pickAvatar(o.avatar),
            lat: o.coords?.lat ?? 0,
            lng: o.coords?.lng ?? 0,
            batteryPercent: o.battery ?? 0,
            activity: parseActivity(action: action, speedKmh: speed),
            timestampMs: (o.connectedAt ?? 0) * 1000,
            isOnline: o.status?.type?.lowercased() == "active",
            speedKmh: speed,
            activitySinceMs: (o.lastHistory?.startunix ?? 0) * 1000
        )
    }

    private static func pickName(_ o: PanelObjectModel) -> String {
        if let u = o.username?.trimmingCharacters(in: .whitespaces), !u.isEmpty {
            return u
        }
        let t = o.title ?? ""
        if let slash = t.firstIndex(of: "/") {
            return String(t[..<slash]).trimmingCharacters(in: .whitespaces)
        }
        return t.trimmingCharacters(in: .whitespaces)
    }

    private static func pickAvatar(_ a: PanelAvatarModel?) -> String {
        guard let a else { return "" }
        return a.medium ?? a.small ?? a.tiny ?? a.large ?? ""
    }

    private static func parseActivity(action: String?, speedKmh: Double) -> Activity {
        switch action {
        case "driving", "move": return .driving
        case "parking", "stop", "stopped": return .still
        case "running": return .running
        case "walking": return .walking
        default: break
        }
        return speedKmh >= 5 ? .driving : .still
    }
}
