import SwiftUI

struct RolePickerSheet: View {
    @Binding var isPresented: Bool
    let circleTitle: String
    var onSelect: (String) -> Void
    var onSkip: () -> Void

    var body: some View {
        BottomSheetContainer(
            isPresented: $isPresented,
            topCornerRadius: 16,
            panelFill: Color(hex: 0xF6F6F6)
        ) { _ in
            RolePanel(
                circleTitle: circleTitle,
                onSelect: onSelect,
                onSkip: onSkip
            )
        }
    }
}

// MARK: - Panel

private struct RolePanel: View {
    let circleTitle: String
    var onSelect: (String) -> Void
    var onSkip: () -> Void

    @Environment(\.dismissBottomSheet) private var dismissBottomSheet

    private let roles = [
        "Mom",
        "Dad",
        "Son / Daughter / Child",
        "Lover",
        "Friend",
        "Grandparent",
        "Other",
    ]

    var body: some View {
        VStack(spacing: 4) {
            headerSection
            rolesSection
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            Capsule()
                .fill(Color(hex: 0xF2F5F9))
                .frame(width: 48, height: 5)

            ZStack {
                Text("Choose Role")
                    .font(AppTypography.bodyMdSemiBold)
                    .foregroundStyle(AppColors.mainBlack)

                HStack {
                    Button {
                        dismissBottomSheet()
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
                    .buttonStyle(.plain)
                    Spacer()
                    Color.clear.frame(width: 32, height: 32)
                }
            }
            .frame(height: 32)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }

    // MARK: - Roles

    private var rolesSection: some View {
        VStack(spacing: 12) {
            ForEach(roles, id: \.self) { role in
                rolePill(title: role, filled: false) {
                    dismissBottomSheet { onSelect(role) }
                }
            }

            rolePill(title: "Skip now role", filled: true) {
                dismissBottomSheet { onSkip() }
            }

            Spacer().frame(height: 90 - 12)

            circleFloatingPill
                .frame(width: 224, height: 44)
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func rolePill(title: String, filled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.bodySmBold)
                .foregroundStyle(AppColors.brand)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.white, in: Capsule())
                .overlay(
                    Capsule().strokeBorder(AppColors.brand, lineWidth: filled ? 0 : 1)
                )
        }
        .buttonStyle(RolePressStyle())
    }

    private var circleFloatingPill: some View {
        HStack(spacing: 4) {
            HStack(spacing: 8) {
                Image(AppVectors.circleGridInterface)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                Text(CirclePillTitle.attributed(circleTitle, textColor: .white))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.16), in: Capsule())

            Image(systemName: "chevron.up")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(Color.white.opacity(0.24), in: Circle())
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color(hex: 0x121212), in: Capsule())
    }
}

private struct RolePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
