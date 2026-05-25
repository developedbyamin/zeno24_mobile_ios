import SwiftUI

@MainActor
@Observable
final class HomeAlertsViewModel {
    var placeAlerts = false
    var startOfMovement = true
    var endOfMovement = true
    var safeDrive = false
    var lowBattery = false
}
