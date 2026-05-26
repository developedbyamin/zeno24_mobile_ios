import SwiftUI

/// Single pill-shaped quick-reply chip rendered inside the chat composer's
/// horizontal scroll (Figma 5865:7251).
struct ChatQuickReplyChip: View {
    let reply: ChatQuickReply
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(reply.iconAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(reply.title)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(AppColors.mainBlack)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(height: 32)
            .background(Color(hex: 0xF2F5F9), in: Capsule())
        }
        .buttonStyle(ChatPressStyle())
    }
}
