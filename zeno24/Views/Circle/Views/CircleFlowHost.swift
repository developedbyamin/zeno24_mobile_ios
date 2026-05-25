import SwiftUI

struct CircleFlowHost<Content: View>: View {
    @ViewBuilder let content: () -> Content

    @Environment(CirclesStore.self) private var circles
    @State private var showCirclePicker = false
    @State private var showCreateCircle = false
    @State private var showJoinCircle = false
    @State private var joinInvitation: JoinInvitationPayload?
    @State private var rolePickerCircleId: String?
    @State private var inviteCircleId: String?
    @Namespace private var circlePillNS

    private struct JoinInvitationPayload: Equatable {
        let code: String
        let circleName: String
        let memberCount: Int
        let avatarUrls: [String]
    }

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

            if showJoinCircle {
                JoinCircleSheet(
                    isPresented: $showJoinCircle,
                    onInvitationLoaded: { code, info in
                        let payload = JoinInvitationPayload(
                            code: code,
                            circleName: info.circleData?.title ?? "Circle",
                            memberCount: info.membersData?.count ?? 0,
                            avatarUrls: (info.membersData ?? []).compactMap(\.avatarUrl)
                        )
                        // Code sheet-i yıxılır, invitation sheet onun yerini
                        // alır — Flutter HomeJoinCircleOverlay ardınca
                        // presentJoinInvitationOverlay çağrısı 1:1.
                        showJoinCircle = false
                        joinInvitation = payload
                    }
                )
                .transition(.opacity)
                .zIndex(1001)
            }

            if let payload = joinInvitation {
                JoinInvitationSheet(
                    isPresented: Binding(
                        get: { joinInvitation != nil },
                        set: { if !$0 { joinInvitation = nil } }
                    ),
                    code: payload.code,
                    circleName: payload.circleName,
                    memberCount: payload.memberCount,
                    avatarUrls: payload.avatarUrls
                )
                .transition(.opacity)
                .zIndex(1002)
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
        .environment(\.openJoinCircle, OpenCirclePickerAction {
            withAnimation(.easeInOut(duration: 0.28)) {
                showJoinCircle = true
            }
        })
        .environment(\.openInviteFlow, OpenInviteFlowAction { circleId in
            rolePickerCircleId = circleId
        })
        .task { await circles.load() }
    }
}
