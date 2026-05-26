import SwiftUI

/// One row inside the chat scroll — avatar on the inside edge, message
/// bubble on the outside. Outgoing messages flip the layout (purple bubble
/// trailing, "me" avatar) and include the seen tick + timestamp footer.
struct ChatBubbleRow: View {
    let message: ChatMessage
    let threadAvatar: String?

    private static let incomingAvatar = AppImages.avatarChatOther
    private static let outgoingAvatar = AppImages.avatarChatMe

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if message.isOutgoing {
                Spacer(minLength: 0)
                outgoingBubble
                avatar(asset: Self.outgoingAvatar)
            } else {
                avatar(asset: threadAvatar ?? Self.incomingAvatar)
                incomingBubble
                Spacer(minLength: 0)
            }
        }
    }

    private func avatar(asset: String) -> some View {
        Image(asset)
            .resizable()
            .scaledToFill()
            .frame(width: 30, height: 30)
            .clipShape(Circle())
    }

    private var incomingBubble: some View {
        Text(message.text)
            .font(AppTypography.bodySmMedium)
            .foregroundStyle(AppColors.mainBlack)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(hex: 0xF2F5F9))
            )
            .frame(maxWidth: 260, alignment: .leading)
    }

    private var outgoingBubble: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(message.text)
                .font(AppTypography.bodySmMedium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Image(AppVectors.chatSeenCheck)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .opacity(message.isSeen ? 1 : 0.4)
                Spacer()
                Text(message.time)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.brand)
        )
        .frame(maxWidth: 260, alignment: .trailing)
    }
}
