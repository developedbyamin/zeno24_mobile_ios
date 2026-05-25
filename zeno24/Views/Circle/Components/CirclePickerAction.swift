import SwiftUI

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
    @Entry var openCreateCircle: OpenCirclePickerAction = OpenCirclePickerAction {}
    @Entry var openInviteFlow: OpenInviteFlowAction = OpenInviteFlowAction { _ in }
    @Entry var circlePillNamespace: Namespace.ID? = nil
    @Entry var circlePickerOpen: Bool = false
}

struct OpenInviteFlowAction {
    private let handler: (String) -> Void
    init(_ handler: @escaping (String) -> Void) { self.handler = handler }
    func callAsFunction(_ circleId: String) { handler(circleId) }
}

enum CirclePillHero {
    static let id = "circle-pill-hero"
}
