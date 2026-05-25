import SwiftUI

struct JoinInvitationSheet: View {
    @Binding var isPresented: Bool
    @Environment(CirclesStore.self) private var circles

    let code: String
    let circleName: String
    let memberCount: Int
    let avatarUrls: [String]

    @State private var isLoading: Bool = false

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

            VStack(spacing: 8) {
                headerPill
                infoCard
                VStack(spacing: 12) {
                    joinButton
                    maybeLaterButton
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
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

    // MARK: - Header pill

    private var headerPill: some View {
        ZStack {
            Text("Join a Circle")
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(AppVectors.backArrow)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(AppColors.mainBlack)
                        .frame(width: 32, height: 32)
                        .background(Color(hex: 0xF2F5F9), in: Circle())
                }
                .buttonStyle(InvitationPressStyle())
                .disabled(isLoading)
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 48)
        .background(Color.white, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.white, lineWidth: 1))
        .contentShape(Capsule())
        .onTapGesture { }
    }

    // MARK: - Info card

    private var infoCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                titleText
                Text("This Circle already has \(memberCount) members.")
                    .font(.custom("PlusJakartaSans-Medium", size: 14))
                    .foregroundStyle(Color(hex: 0x8B98A8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2.8)
            }
            avatarsRow
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture { }
    }

    private var titleText: some View {
        VStack(spacing: 0) {
            Text("You\u{2019}ve been invited to")
            Text("\(circleName) 👋")
        }
        .font(.custom("PlusJakartaSans-SemiBold", size: 18))
        .foregroundStyle(AppColors.mainBlack)
        .multilineTextAlignment(.center)
        .lineSpacing(18 * 0.2)
    }

    private var avatarsRow: some View {
        let displayUrls = Array(avatarUrls.prefix(3))
        let displayCount = displayUrls.count
        let showOverflow = memberCount > displayCount
        let extra = memberCount - displayCount

        return HStack(spacing: -20) {
            ForEach(Array(displayUrls.enumerated()), id: \.offset) { index, url in
                avatarView(url: url)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: index == 0 ? 3 : 2)
                    )
            }
            if showOverflow {
                ZStack {
                    Circle()
                        .fill(Color(hex: 0xF2F5F9))
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

    @ViewBuilder
    private func avatarView(url: String) -> some View {
        if let parsed = URL(string: url) {
            AsyncImage(url: parsed) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Color(hex: 0xEDBBD6)
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())
        } else {
            Color(hex: 0xEDBBD6)
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
            .frame(height: 52)
            .background(AppColors.brand, in: Capsule())
            .opacity(isLoading ? 0.85 : 1.0)
        }
        .buttonStyle(InvitationPressStyle())
        .disabled(isLoading)
    }

    private var maybeLaterButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Maybe Later")
                .font(AppTypography.bodySmBold)
                .foregroundStyle(AppColors.mainBlack)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.white, in: Capsule())
        }
        .buttonStyle(InvitationPressStyle())
        .disabled(isLoading)
    }

    // MARK: - Actions

    private func handleJoin() {
        guard !isLoading else { return }
        Task {
            isLoading = true
            do {
                try await circles.join(code: code)
                isLoading = false
                dismiss()
            } catch {
                isLoading = false
                OverlayHelper.shared.showFailure(error)
            }
        }
    }

    private func dismiss() {
        guard !isLoading else { return }
        withAnimation(.easeInOut(duration: 0.28)) {
            isPresented = false
        }
    }
}

// MARK: - Press style

private struct InvitationPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
