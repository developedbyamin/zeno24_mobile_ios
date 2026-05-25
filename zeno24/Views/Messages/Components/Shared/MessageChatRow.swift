import SwiftUI

struct MessageChatRow: View {
    let title: String
    let preview: String
    let time: String
    let avatarAsset: String?
    let initialBackground: Color
    let unreadCount: Int
    let highlighted: Bool

    init(title: String,
         preview: String,
         time: String,
         avatarAsset: String? = nil,
         initialBackground: Color = .gray,
         unreadCount: Int = 0,
         highlighted: Bool = false) {
        self.title = title
        self.preview = preview
        self.time = time
        self.avatarAsset = avatarAsset
        self.initialBackground = initialBackground
        self.unreadCount = unreadCount
        self.highlighted = highlighted
    }

    var body: some View {
        HStack(spacing: 10) {
            avatar
            VStack(spacing: 4) {
                HStack {
                    Text(title)
                        .font(AppTypography.bodySmSemiBold)
                        .foregroundStyle(AppColors.mainBlack)
                    Spacer()
                    Text(time)
                        .font(AppTypography.bodyXsSemiBold)
                        .foregroundStyle(Color(hex: 0x8B98A8))
                }
                HStack {
                    HStack(spacing: 4) {
                        Image(AppVectors.chatSeenCheck)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(AppColors.brand)
                        Text(preview)
                            .font(.custom("PlusJakartaSans-Regular", size: 14))
                            .foregroundStyle(Color(hex: 0x8B98A8))
                            .lineLimit(1)
                    }
                    Spacer(minLength: 0)
                    if unreadCount > 0 {
                        Text("\(unreadCount)")
                            .font(AppTypography.body2XsBold)
                            .foregroundStyle(.white)
                            .frame(minWidth: 16, minHeight: 16)
                            .background(Color(hex: 0xF70505), in: Circle())
                    }
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(highlighted ? Color(hex: 0xF2F5F9) : .clear,
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    @ViewBuilder
    private var avatar: some View {
        if let avatarAsset {
            Image(avatarAsset)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
        } else {
            ZStack {
                Circle().fill(initialBackground)
                Text(String(title.prefix(1)))
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(.white)
            }
            .frame(width: 48, height: 48)
        }
    }
}
