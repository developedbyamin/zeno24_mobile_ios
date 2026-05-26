import SwiftUI

/// Bottom composer for the chat thread (Figma 5865:7249) — a row of
/// quick-reply chips above a rounded text input with a send button. Owns
/// only its draft state; sending is delegated to the parent so the message
/// list stays the single source of truth.
struct ChatComposer: View {
    @Binding var draft: String
    var focused: FocusState<Bool>.Binding
    let onSend: () -> Void
    let onQuickReply: (ChatQuickReply) -> Void

    var body: some View {
        VStack(spacing: 12) {
            quickReplies
            inputRow
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(
            // White background extends past the safe area so the
            // home-indicator strip is filled by the composer itself —
            // otherwise the screen's `#F6F6F6` background bleeds through
            // underneath and the composer reads as "floating".
            Color.white
                .clipShape(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(topLeading: 16, topTrailing: 16),
                        style: .continuous
                    )
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private var quickReplies: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ChatQuickReply.allCases) { reply in
                    ChatQuickReplyChip(reply: reply) { onQuickReply(reply) }
                }
            }
        }
        // Lets the chips bleed slightly past the composer's rounded edge
        // without clipping the press feedback.
        .padding(.horizontal, -16)
        .padding(.horizontal, 16)
    }

    private var inputRow: some View {
        HStack(spacing: 8) {
            TextField(
                "",
                text: $draft,
                prompt: Text(AppStrings.Chat.placeholder)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            )
            .font(AppTypography.bodySmSemiBold)
            .foregroundStyle(AppColors.mainBlack)
            .submitLabel(.send)
            .focused(focused)
            .onSubmit(onSend)

            sendButton
        }
        .padding(.leading, 16)
        .padding(.trailing, 4)
        .frame(height: 48)
        .background(Color.white, in: Capsule())
        .overlay(Capsule().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 1))
    }

    private var sendButton: some View {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        let isActive = !trimmed.isEmpty
        return Button(action: onSend) {
            Image(systemName: "arrow.up")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(
                    Circle().fill(isActive ? AppColors.brand : Color(hex: 0xC9C9D6))
                )
        }
        .buttonStyle(ChatPressStyle())
        .disabled(!isActive)
        .animation(.easeInOut(duration: 0.18), value: isActive)
    }
}
