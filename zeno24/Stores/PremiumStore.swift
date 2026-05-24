import Foundation

/// Premium / paywall state — mirrors premium_sheet_controller.dart
@MainActor
@Observable
final class PremiumStore {
    var isPremium: Bool = false
    var isSheetVisible: Bool = false
    var trigger: Trigger?

    enum Trigger: String {
        case manual
        case addCircle
        case history
        case unlimitedMembers
    }

    func presentSheet(_ trigger: Trigger) {
        self.trigger = trigger
        self.isSheetVisible = true
    }

    func dismiss() {
        isSheetVisible = false
        trigger = nil
    }
}
