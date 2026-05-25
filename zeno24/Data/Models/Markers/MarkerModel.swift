import Foundation

enum Activity: String, Codable, Hashable {
    case unspecified, still, walking, running, driving
}

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
