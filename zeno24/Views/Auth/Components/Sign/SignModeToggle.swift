import SwiftUI

struct SignModeToggle: View {
    @Bindable var store: AuthStore
    @FocusState.Binding var focus: SignFocus?

    var body: some View {
        Button(action: toggle) {
            HStack(spacing: 8) {
                Text(promptLabel)
                    .font(AppTypography.bodySmSemiBold)
                    .foregroundStyle(.white)

                Text(actionLabel)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white, in: Capsule())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.12), in: Capsule())
            .overlay {
                Capsule().strokeBorder(Color.white.opacity(0.16), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var promptLabel: String {
        store.contactMode == .phone
            ? AppStrings.Auth.Toggle.dontHaveWhatsapp
            : AppStrings.Auth.Toggle.dontHaveEmail
    }

    private var actionLabel: String {
        store.contactMode == .phone
            ? AppStrings.Auth.Toggle.useEmail
            : AppStrings.Auth.Toggle.useWhatsapp
    }

    private func toggle() {
        Haptics.impact(.light)
        withAnimation(.smooth(duration: 0.32)) {
            store.contactMode = store.contactMode == .phone ? .email : .phone
        }
        DispatchQueue.main.async {
            focus = store.contactMode == .phone ? .phone : .email
        }
    }
}
