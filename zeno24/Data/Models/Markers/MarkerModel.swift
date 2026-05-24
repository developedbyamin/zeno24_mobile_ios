import Foundation

/// User activity classification — mirrors Flutter `Activity` enum.
enum Activity: String, Codable, Hashable {
    case unspecified, still, walking, running, driving
}

/// Flat marker view-model consumed by the map. Built from
/// `PanelObjectModel` in `MarkersRepository.sync` — same shape as
/// Flutter's `marker_model.dart`.
struct MarkerModel: Identifiable, Hashable {
    let userId: String
    let displayName: String
    let avatarUrl: String
    let lat: Double
    let lng: Double
    let batteryPercent: Int
    let activity: Activity
    let timestampMs: Int
    let isOnline: Bool
    let speedKmh: Double
    let activitySinceMs: Int

    var id: String { userId }
}
