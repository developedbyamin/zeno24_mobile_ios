import SwiftUI

/// Logout confirmation modal (Figma 8883:8637). Centered white card on a
/// translucent black backdrop, 3D logout illustration at the top, title +
/// subtitle, then two pill buttons — neutral "Cancel" on the left, black
/// destructive "Leave" on the right. Mirrors the Flutter
/// `LogoutConfirmDialog` so the copy + behaviour line up across platforms.
struct LogoutConfirmDialog: View {
    @Binding var isPresented: Bool
    var isLoading: Bool = false
    var onConfirm: () -> Void

    @State private var didAppear = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .opacity(didAppear ? 1 : 0)
                .onTapGesture { if !isLoading { dismiss() } }

            // Bottom-anchored, matching Figma 8883:8637 and the existing
            // PremiumOutcomeDialog placement — pinned to the bottom safe area
            // with a small inset, not vertically centered.
            VStack {
                Spacer(minLength: 0)
                card
                    .padding(.horizontal, 12)
                    .padding(.bottom, 24)
                    .scaleEffect(didAppear ? 1 : 0.92, anchor: .bottom)
                    .opacity(didAppear ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.22)) {
                didAppear = true
            }
        }
    }

    // MARK: - Card

    private var card: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Image(AppImages.emojiLogout3d)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 166, height: 166)

                Text(AppStrings.Settings.logoutConfirmTitle)
                    .font(AppTypography.bodyLgSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                Spacer().frame(height: 8)

                Text(AppStrings.Settings.logoutConfirmMessage)
                    .font(AppTypography.bodySmMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                Spacer().frame(height: 24)

                HStack(spacing: 8) {
                    Button(action: { dismiss() }) {
                        Text(AppStrings.Settings.logoutConfirmCancel)
                            .font(AppTypography.bodySmBold)
                            .foregroundStyle(AppColors.mainBlack)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(hex: 0xF2F5F9), in: Capsule())
                    }
                    .buttonStyle(LogoutPressStyle())
                    .disabled(isLoading)

                    Button(action: onConfirm) {
                        ZStack {
                            Text(AppStrings.Settings.logoutConfirmAction)
                                .font(AppTypography.bodySmBold)
                                .foregroundStyle(.white)
                                .opacity(isLoading ? 0 : 1)

                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppColors.mainBlack, in: Capsule())
                    }
                    .buttonStyle(LogoutPressStyle())
                    .disabled(isLoading)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }

            Button(action: { dismiss() }) {
                Image(AppVectors.closeSmall)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(AppColors.mainBlack)
                    .frame(width: 32, height: 32)
                    .background(Color.white, in: Circle())
                    .overlay(Circle().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 1))
            }
            .buttonStyle(LogoutPressStyle())
            .padding(.top, 16)
            .padding(.trailing, 16)
            .disabled(isLoading)
        }
        .background(Color.white, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .onTapGesture { } // Swallow taps so the backdrop's dismiss doesn't fire.
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.18)) {
            didAppear = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            isPresented = false
        }
    }
}

private struct LogoutPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
