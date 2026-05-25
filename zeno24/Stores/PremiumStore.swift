import Foundation

@MainActor
@Observable
final class PremiumStore {
    var isPremium: Bool = false
    var isSheetVisible: Bool = false
    var trigger: Trigger?

    var outcome: PremiumOutcomeDialog.Variant?

    enum Trigger: String {
        case firstLaunch
        case manual
        case addCircle
        case history
        case unlimitedMembers
    }

    // Flutter parity: every outcome trigger alternates between success and
    // error (`trialAttemptIndex % 2 == 0`). Pure mock — no real billing.
    private var trialAttemptIndex: Int = 0

    func presentSheet(_ trigger: Trigger) {
        self.trigger = trigger
        self.isSheetVisible = true
    }

    /// Show the premium upsell on every MainView mount. Mirrors the Flutter
    /// `addPostFrameCallback → premiumSheetControllerProvider.show()` trigger
    /// which fires on every cold start with no persistence gate.
    func presentOnFirstLaunchIfNeeded() {
        presentSheet(.firstLaunch)
    }

    func dismiss() {
        isSheetVisible = false
        trigger = nil
    }

    /// Triggered by the premium sheet's "Start 7-day free trial" CTA and by
    /// the home alerts panel's premium promo card. Alternates success/error
    /// on each call (1:1 with `HomePlatformView.presentPremiumOutcomeDialog`).
    func presentOutcomeDialog() {
        let isSuccess = (trialAttemptIndex % 2) == 0
        trialAttemptIndex += 1
        outcome = isSuccess ? .success : .error
    }

    func dismissOutcome() {
        outcome = nil
    }
}
