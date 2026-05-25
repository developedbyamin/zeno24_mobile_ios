import Foundation

/// The auth flow is not modelled as routes — it's a state machine
/// driven by `AuthStore.phase`. Pushing/popping auth screens loses
/// the entrance animations and shared state, so we keep them flat
/// and switch with `.transition`.
enum AppRoute: Hashable {
    case messages
    case chat(circleId: String)
    case notifications
    case profile
    case settings

    case health
    case kids
    case driving
    case premium
}
