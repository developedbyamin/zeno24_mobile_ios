import SwiftUI

struct JoinInvitationStep: View {
    struct Payload: Equatable, Identifiable {
        let id: UUID
        let code: String
        let circleName: String
        let memberCount: Int
        let avatarUrls: [String]

        init(
            id: UUID = UUID(),
            code: String,
            circleName: String,
            memberCount: Int,
            avatarUrls: [String]
        ) {
            self.id = id
            self.code = code
            self.circleName = circleName
            self.memberCount = memberCount
            self.avatarUrls = avatarUrls
        }

        static func == (lhs: Payload, rhs: Payload) -> Bool { lhs.id == rhs.id }
    }

    let payload: Payload
    var onBack: () -> Void
    var onJoined: () -> Void

    @Environment(CirclesStore.self) private var circles
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            FlowHeaderPill(
                title: "Join a Circle",
                disabled: isLoading,
                onBack: handleBack
            )
            infoCard
            VStack(spacing: 12) {
                joinButton
                maybeLaterButton
            }
        }
        .padding(.horizontal, CircleFlowMetrics.contentHorizontalPadding)
        .padding(.top, CircleFlowMetrics.contentTopPadding)
        .padding(.bottom, CircleFlowMetrics.contentBottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    // MARK: - Info card

    private var infoCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                titleText
                Text("This Circle already has \(payload.memberCount) members.")
                    .font(.custom("PlusJakartaSans-Medium", size: 14))
                    .foregroundStyle(AppColors.textMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2.8)
            }
            avatarsRow
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var titleText: some View {
        VStack(spacing: 0) {
            Text("You\u{2019}ve been invited to")
            Text("\(payload.circleName) 👋")
        }
        .font(.custom("PlusJakartaSans-SemiBold", size: 18))
        .foregroundStyle(AppColors.mainBlack)
        .multilineTextAlignment(.center)
        .lineSpacing(18 * 0.2)
    }

    private var avatarsRow: some View {
        let displayUrls = Array(payload.avatarUrls.prefix(3))
        let displayCount = displayUrls.count
        let showOverflow = payload.memberCount > displayCount
        let extra = payload.memberCount - displayCount

        return HStack(spacing: -20) {
            ForEach(Array(displayUrls.enumerated()), id: \.offset) { index, url in
                avatarView(url: url)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: index == 0 ? 3 : 2)
                    )
            }
            if showOverflow {
                ZStack {
                    Circle().fill(AppColors.surfaceMuted)
                    Text(extra >= 10 ? "10+" : "\(extra)+")
                        .font(AppTypography.bodySmBold)
                        .foregroundStyle(AppColors.mainBlack)
                }
                .frame(width: 56, height: 56)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
        }
        .frame(height: 56)
    }

    private static let avatarFallback = Color(hex: 0xEDBBD6)

    @ViewBuilder
    private func avatarView(url: String) -> some View {
        if let parsed = URL(string: url) {
            AsyncImage(url: parsed) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Self.avatarFallback
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())
        } else {
            Self.avatarFallback
                .frame(width: 56, height: 56)
                .clipShape(Circle())
        }
    }

    // MARK: - Buttons

    private var joinButton: some View {
        Button(action: handleJoin) {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Join")
                        .font(AppTypography.bodySmBold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: CircleFlowMetrics.primaryButtonHeight)
            .background(AppColors.brand, in: Capsule())
            .opacity(isLoading ? 0.85 : 1.0)
        }
        .buttonStyle(ScalePressStyle())
        .disabled(isLoading)
    }

    private var maybeLaterButton: some View {
        Button(action: handleBack) {
            Text("Maybe Later")
                .font(AppTypography.bodySmBold)
                .foregroundStyle(AppColors.mainBlack)
                .frame(maxWidth: .infinity)
                .frame(height: CircleFlowMetrics.primaryButtonHeight)
                .background(Color.white, in: Capsule())
        }
        .buttonStyle(ScalePressStyle())
        .disabled(isLoading)
    }

    // MARK: - Actions

    private func handleJoin() {
        guard !isLoading else { return }
        Task {
            isLoading = true
            do {
                try await circles.join(code: payload.code)
                isLoading = false
                onJoined()
            } catch {
                isLoading = false
                OverlayHelper.shared.showFailure(error)
            }
        }
    }

    private func handleBack() {
        guard !isLoading else { return }
        onBack()
    }
}
