import SwiftUI

/// Notification row — Figma 5421:8154 "Profile notifications".
/// 48pt avatar (image or colored circle + first letter) with a 24pt colored
/// status badge overlaid bottom-right.
struct NotificationRow: View {
    let title: String
    let time: String
    let preview: String
    /// When non-nil, displays an image asset as the avatar. When nil, shows
    /// `title.prefix(1)` on `avatarBackground`.
    let avatarAsset: String?
    let avatarBackground: Color
    /// Color of the bottom-right status badge.
    let badgeColor: Color
    /// Asset name OR SF Symbol name used inside the badge.
    let badgeAsset: BadgeAsset

    enum BadgeAsset {
        case vector(String)   // AppVectors.* name (template)
        case systemImage(String)
    }

    init(title: String,
         time: String,
         preview: String = AppStrings.Notifications.preview,
         avatarAsset: String? = nil,
         avatarBackground: Color = .gray,
         badgeColor: Color,
         badgeAsset: BadgeAsset) {
        self.title = title
        self.time = time
        self.preview = preview
        self.avatarAsset = avatarAsset
        self.avatarBackground = avatarBackground
        self.badgeColor = badgeColor
        self.badgeAsset = badgeAsset
    }

    var body: some View {
        HStack(spacing: 10) {
            avatarWithBadge
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
                    Text(preview)
                        .font(.custom("PlusJakartaSans-Regular", size: 14))
                        .foregroundStyle(Color(hex: 0x8B98A8))
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(8)
    }

    private var avatarWithBadge: some View {
        ZStack(alignment: .bottomTrailing) {
            avatar
            badge
                .offset(x: 4, y: 0)
        }
        .frame(width: 48, height: 48)
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
                Circle().fill(avatarBackground)
                Text(String(title.prefix(1)))
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(.white)
            }
            .frame(width: 48, height: 48)
        }
    }

    private var badge: some View {
        ZStack {
            Circle().fill(badgeColor)
            switch badgeAsset {
            case .vector(let name):
                Image(name)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.white)
            case .systemImage(let name):
                Image(systemName: name)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 24, height: 24)
    }
}
