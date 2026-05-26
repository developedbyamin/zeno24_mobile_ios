import Foundation

/// Coordinates the cold-start fetches that gate access to the main app:
/// `/main/settings`, `/circles/list`, and the navimax `panelobjects/synclist`
/// member feed. While running, `RootView` keeps the splash screen up; once
/// every fetch returns (success or failure), the user is dropped into the
/// main view. Mirrors the Flutter app's behaviour where these three Riverpod
/// providers are pre-warmed before navigating away from `splash`.
///
/// Error policy: non-auth failures don't block the user — each underlying
/// store keeps its own `errorMessage` and the main view can pull-to-refresh.
/// Auth failures (HTTP 401 or backend code 1001) trigger the existing
/// `.sessionExpired` notification observed by `AuthStore`, which kicks the
/// user back to the auth flow.
@MainActor
@Observable
final class BootstrapStore {
    enum State: Equatable {
        case idle
        case loading
        case ready
    }

    var state: State = .idle

    private weak var settings: SettingsStore?
    private weak var circles: CirclesStore?
    private weak var markers: MarkersStore?
    private weak var premium: PremiumStore?

    private var currentTask: Task<Void, Never>?

    func attach(
        settings: SettingsStore,
        circles: CirclesStore,
        markers: MarkersStore,
        premium: PremiumStore
    ) {
        self.settings = settings
        self.circles = circles
        self.markers = markers
        self.premium = premium
    }

    /// Kick off the three loads in parallel. If the user is already past
    /// `.loading`, this is a no-op so re-renders don't refire bootstrap.
    func start() {
        guard state == .idle, currentTask == nil else { return }
        guard let settings, let circles, let markers else {
            assertionFailure("BootstrapStore.start called before attach")
            return
        }
        state = .loading
        currentTask = Task { [weak self] in
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await settings.load() }
                group.addTask { await circles.load() }
                group.addTask { await markers.syncOnce() }
            }
            // Background polling lives with the authenticated session, not
            // with any single view. `markers.reset()` (called from
            // `BootstrapStore.reset` on logout) tears it down.
            markers.startSyncing()
            // Surface the once-per-session premium upsell here so it isn't
            // tied to HomeView lifecycle — re-entering Home from any other
            // tab no longer re-fires the sheet.
            self?.premium?.presentOnFirstLaunchIfNeeded()
            self?.finish()
        }
    }

    /// Drop back to `.idle` so the next authenticated transition can re-run
    /// bootstrap from scratch. Called when the user logs out — also wipes
    /// the cached account / circle / member state so the next user doesn't
    /// see the previous session's data flash before bootstrap finishes.
    func reset() {
        currentTask?.cancel()
        currentTask = nil
        settings?.reset()
        circles?.reset()
        markers?.reset()
        premium?.resetSession()
        state = .idle
    }

    private func finish() {
        currentTask = nil
        state = .ready
    }
}
