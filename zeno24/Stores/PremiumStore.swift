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

    /// Whether the first-launch upsell has already been surfaced during the
    /// current session. Driven by `BootstrapStore.start()` so it fires once
    /// per cold start, not once per HomeView mount.
    private var didShowFirstLaunchUpsell: Bool = false

    func presentSheet(_ trigger: Trigger) {
        self.trigger = trigger
        self.isSheetVisible = true
    }

    /// Surface the premium upsell exactly once per session (cold start or
    /// post-login bootstrap). Subsequent calls — re-entering Home from
    /// Settings/Notifications/etc — are no-ops.
    func presentOnFirstLaunchIfNeeded() {
        guard !didShowFirstLaunchUpsell else { return }
        didShowFirstLaunchUpsell = true
        presentSheet(.firstLaunch)
    }

    /// Clear the once-per-session flag so the next login surfaces the upsell
    /// again. Called from `BootstrapStore.reset()` on logout.
    func resetSession() {
        didShowFirstLaunchUpsell = false
        isSheetVisible = false
        trigger = nil
        outcome = nil
        trialAttemptIndex = 0
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
