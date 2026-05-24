import Foundation
import CoreLocation
import UserNotifications

/// Runtime permission state — mirrors permissions_provider.dart
@MainActor
@Observable
final class PermissionsStore: NSObject {
    var locationAuthorization: CLAuthorizationStatus = .notDetermined
    var notificationAuthorization: UNAuthorizationStatus = .notDetermined

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationAuthorization = locationManager.authorizationStatus
        Task { await refreshNotificationStatus() }
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestAlwaysLocation() {
        locationManager.requestAlwaysAuthorization()
    }

    func requestNotifications() async {
        let granted = (try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        await refreshNotificationStatus()
        _ = granted
    }

    func refreshNotificationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        notificationAuthorization = settings.authorizationStatus
    }
}

extension PermissionsStore: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.locationAuthorization = manager.authorizationStatus
        }
    }
}
