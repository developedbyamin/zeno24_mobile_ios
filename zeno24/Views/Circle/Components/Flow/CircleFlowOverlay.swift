import SwiftUI

struct CircleFlowOverlay: View {
    @Binding var step: CircleFlowStep?
    @Environment(CirclesStore.self) private var circles
    @State private var appearOpacity: Double = 0

    var body: some View {
        ZStack(alignment: .top) {
            backgroundShape
                .ignoresSafeArea()
                .contentShape(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
                        style: .continuous
                    )
                )
                .onTapGesture { dismiss() }

            content
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .opacity(appearOpacity)
        .onAppear {
            withAnimation(.easeOut(duration: CircleFlowMetrics.overlayFadeDuration)) {
                appearOpacity = 1
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        ZStack {
            switch step {
            case .picker, .none:
                CirclePickerStep(
                    onClose: { dismiss() },
                    onCreate: { step = .create },
                    onJoin: { step = .join }
                )
                .transition(.opacity)
            case .create:
                CreateCircleStep(
                    onBack: { step = .picker },
                    onCompleted: { dismiss() }
                )
                .transition(.opacity)
            case .join:
                JoinCircleStep(
                    onBack: { step = .picker },
                    onInvitationLoaded: { code, info in
                        step = .invitation(.init(
                            code: code,
                            circleName: info.circleData?.title ?? "Circle",
                            memberCount: info.membersData?.count ?? 0,
                            avatarUrls: (info.membersData ?? []).compactMap(\.avatarUrl)
                        ))
                    }
                )
                .transition(.opacity)
            case .invitation(let payload):
                JoinInvitationStep(
                    payload: payload,
                    onBack: { step = .join },
                    onJoined: { dismiss() }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: CircleFlowMetrics.stepCrossFadeDuration), value: step)
    }

    // MARK: - Background

    private var backgroundShape: some View {
        UnevenRoundedRectangle(
            cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
            style: .continuous
        )
        .fill(.ultraThinMaterial)
        .opacity(0.7)
        .overlay(
            UnevenRoundedRectangle(
                cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
                style: .continuous
            )
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0xF9/255, green: 0xF1/255, blue: 0xFB/255).opacity(0.7),
                        Color(red: 0xCF/255, green: 0xBD/255, blue: 0xD3/255).opacity(0.7),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        )
    }

    // MARK: - Dismissal

    private func dismiss() {
        withAnimation(
            .easeIn(duration: CircleFlowMetrics.overlayDismissDuration),
            completionCriteria: .removed
        ) {
            appearOpacity = 0
        } completion: {
            step = nil
        }
    }
}

// MARK: - Step model

enum CircleFlowStep: Equatable {
    case picker
    case create
    case join
    case invitation(JoinInvitationStep.Payload)
}
