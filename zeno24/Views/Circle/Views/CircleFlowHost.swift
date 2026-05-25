import SwiftUI

struct CircleFlowHost<Content: View>: View {
    @ViewBuilder let content: () -> Content

    @State private var circles = CirclesStore()
    @State private var showCirclePicker = false
    @State private var showCreateCircle = false
    @State private var rolePickerCircleId: String?
    @State private var inviteCircleId: String?
    @Namespace private var circlePillNS

    var body: some View {
        ZStack {
            content()

            if showCirclePicker {
                CirclePickerSheet(isPresented: $showCirclePicker, namespace: circlePillNS)
                    .zIndex(1000)
            }

            if showCreateCircle {
                CreateCircleSheet(isPresented: $showCreateCircle)
                    .transition(.opacity)
                    .zIndex(1001)
            }

            if let id = rolePickerCircleId {
                let title = circles.circles.first(where: { $0.id == id })?.name ?? "Family"
                RolePickerSheet(
                    isPresented: Binding(
                        get: { rolePickerCircleId != nil },
                        set: { if !$0 { rolePickerCircleId = nil } }
                    ),
                    circleTitle: title,
                    onSelect: { _ in inviteCircleId = id },
                    onSkip: { inviteCircleId = id }
                )
                .zIndex(1002)
            }

            if let id = inviteCircleId {
                InviteMemberSheet(
                    isPresented: Binding(
                        get: { inviteCircleId != nil },
                        set: { if !$0 { inviteCircleId = nil } }
                    ),
                    circleId: id,
                    avatarUrl: circles.circles.first(where: { $0.id == id })?.avatarUrl,
                    invite: { try await circles.invite(circleId: $0) }
                )
                .zIndex(1003)
            }
        }
        .environment(circles)
        .environment(\.circlePillNamespace, circlePillNS)
        .environment(\.circlePickerOpen, showCirclePicker)
        .environment(\.openCirclePicker, OpenCirclePickerAction {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                showCirclePicker = true
            }
        })
        .environment(\.openCreateCircle, OpenCirclePickerAction {
            withAnimation(.easeInOut(duration: 0.28)) {
                showCreateCircle = true
            }
        })
        .environment(\.openInviteFlow, OpenInviteFlowAction { circleId in
            rolePickerCircleId = circleId
        })
        .task { await circles.load() }
    }
}
