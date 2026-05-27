import SwiftUI

struct CircleFlowHost<Content: View>: View {
    @ViewBuilder let content: () -> Content

    @Environment(CirclesStore.self) private var circles
    @Environment(DeepLinkStore.self) private var deepLink
    @State private var flowStep: CircleFlowStep?
    @State private var rolePickerSheetCircleId: String?
    @State private var inviteMemberSheetCircleId: String?
    @State private var invitationInFlight: Bool = false

    var body: some View {
        ZStack {
            content()

            ZStack {
                if let step = flowStep {
                    CircleFlowOverlay(step: bindingForStep(step))
                        .zIndex(1000)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .all)

            if let id = rolePickerSheetCircleId {
                let title = circles.circles.first(where: { $0.id == id })?.name ?? "Family"
                RolePickerSheet(
                    isPresented: Binding(
                        get: { rolePickerSheetCircleId != nil },
                        set: { if !$0 { rolePickerSheetCircleId = nil } }
                    ),
                    circleTitle: title,
                    onSelect: { _ in inviteMemberSheetCircleId = id },
                    onSkip: { inviteMemberSheetCircleId = id }
                )
                .zIndex(1002)
            }

            if let id = inviteMemberSheetCircleId {
                InviteMemberSheet(
                    isPresented: Binding(
                        get: { inviteMemberSheetCircleId != nil },
                        set: { if !$0 { inviteMemberSheetCircleId = nil } }
                    ),
                    circleId: id,
                    avatarUrl: circles.circles.first(where: { $0.id == id })?.avatarUrl,
                    invite: { try await circles.invite(circleId: $0) }
                )
                .zIndex(1003)
            }
        }
        .environment(circles)
        .environment(\.circlePickerOpen, flowStep != nil)
        .environment(\.openCirclePicker, OpenCirclePickerAction { open(.picker) })
        .environment(\.openCreateCircle, OpenCirclePickerAction { open(.create) })
        .environment(\.openJoinCircle, OpenCirclePickerAction { open(.join) })
        .environment(\.openInviteFlow, OpenInviteFlowAction { circleId in
            rolePickerSheetCircleId = circleId
        })
        .task { await circles.load() }
        .onAppear { processPendingInvite() }
        .onChange(of: deepLink.pendingInviteCode) { _, _ in
            processPendingInvite()
        }
    }

    private func open(_ step: CircleFlowStep) {
        flowStep = step
    }

    private func processPendingInvite() {
        guard !invitationInFlight else { return }
        guard let code = deepLink.pendingInviteCode, !code.isEmpty else { return }
        invitationInFlight = true
        Task {
            defer { invitationInFlight = false }
            do {
                let info = try await circles.info(code: code)
                deepLink.clearPendingInvite()
                flowStep = .invitation(.init(
                    code: code,
                    circleName: info.circleData?.title ?? "Circle",
                    memberCount: info.membersData?.count ?? 0,
                    avatarUrls: (info.membersData ?? []).compactMap(\.avatarUrl)
                ))
            } catch {
                deepLink.clearPendingInvite()
                OverlayHelper.shared.showFailure(error)
            }
        }
    }

    private func bindingForStep(_ current: CircleFlowStep) -> Binding<CircleFlowStep?> {
        Binding(
            get: { flowStep },
            set: { flowStep = $0 }
        )
    }
}
