import SwiftUI

/// Action injected via environment so any view can open the circle picker
/// sheet without owning its presentation state.
struct OpenCirclePickerAction {
    private let handler: () -> Void

    init(_ handler: @escaping () -> Void) {
        self.handler = handler
    }

    func callAsFunction() {
        handler()
    }
}

extension EnvironmentValues {
    @Entry var openCirclePicker: OpenCirclePickerAction = OpenCirclePickerAction {}
    /// Presents the "Create a Circle" overlay (Figma 4991:17213). Closures
    /// run from any view via `@Environment(\.openCreateCircle)`.
    @Entry var openCreateCircle: OpenCirclePickerAction = OpenCirclePickerAction {}
    /// Opens the role-picker sheet for a specific circle id, which then
    /// chains into the invite-member sheet on selection / skip (Flutter
    /// `circlesOverlayDidTapAddRole` → `presentRolePicker` →
    /// `presentInviteCircleSheet`).
    @Entry var openInviteFlow: OpenInviteFlowAction = OpenInviteFlowAction { _ in }
    /// Shared Namespace.ID used to drive the hero pill → overlay morph via
    /// `matchedGeometryEffect`. `nil` when the host hasn't set it up yet.
    @Entry var circlePillNamespace: Namespace.ID? = nil
    /// Whether the circle picker overlay is currently presented. Pills read
    /// this to remove themselves from the tree (so the destination pill
    /// inside the overlay becomes the only matched view).
    @Entry var circlePickerOpen: Bool = false
}

/// Same shape as `OpenCirclePickerAction` but accepts the target circle id
/// so a single shared sheet host can present the flow per row.
struct OpenInviteFlowAction {
    private let handler: (String) -> Void
    init(_ handler: @escaping (String) -> Void) { self.handler = handler }
    func callAsFunction(_ circleId: String) { handler(circleId) }
}

/// `matchedGeometryEffect` identifier shared between the source pill (in any
/// tab's screen chrome) and the destination pill at the top of the overlay.
enum CirclePillHero {
    static let id = "circle-pill-hero"
}
