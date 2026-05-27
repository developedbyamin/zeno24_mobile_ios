import SwiftUI

struct SettingsProfileCard: View {
    var name: String = ""
    var email: String = ""
    var avatarURL: URL? = nil
    var isLoading: Bool = false
    var onProfileTap: (() -> Void)? = nil
    var onUpgradeTap: (() -> Void)? = nil

    private var resolvedName: String {
        name.isEmpty ? AppStrings.Settings.userName : name
    }

    private var resolvedEmail: String {
        email.isEmpty ? AppStrings.Settings.userEmail : email
    }

    private var initial: String {
        let source = name.isEmpty ? resolvedEmail : name
        return source
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .first
            .map { String($0).uppercased() } ?? "?"
    }

    var body: some View {
        VStack(spacing: 16) {
            Button {
                onProfileTap?()
            } label: {
                HStack(spacing: 10) {
                    avatar
                        .frame(width: 56, height: 56)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(resolvedName)
                            .font(AppTypography.bodyMdSemiBold)
                            .foregroundStyle(AppColors.mainBlack)
                            .redacted(reason: isLoading ? .placeholder : [])
                        Text(resolvedEmail)
                            .font(AppTypography.bodyXsMedium)
                            .foregroundStyle(Color(hex: 0x8B98A8))
                            .redacted(reason: isLoading ? .placeholder : [])
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image(AppVectors.arrowRight)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(AppColors.mainBlack)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            upgradeBanner
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    @ViewBuilder
    private var avatar: some View {
        if let avatarURL {
            AsyncImage(url: avatarURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .empty, .failure:
                    initialFallback
                @unknown default:
                    initialFallback
                }
            }
            .clipShape(Circle())
        } else {
            initialFallback
        }
    }

    private var initialFallback: some View {
        ZStack {
            Circle().fill(Color(hex: 0x0F85EB))
            Text(initial)
                .font(AppTypography.bodyMdBold)
                .foregroundStyle(.white)
        }
    }

    private var upgradeBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0xAC4CC0), Color(hex: 0xEB6659)],
                startPoint: .leading,
                endPoint: .trailing
            )

            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        .frame(width: 95, height: 95)
                        .position(x: proxy.size.width - 30, y: -10)
                    Circle()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        .frame(width: 94, height: 94)
                        .position(x: proxy.size.width - 90, y: proxy.size.height + 8)
                }
                .allowsHitTesting(false)
            }

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(AppStrings.Settings.heroLine1)
                    Text(AppStrings.Settings.heroLine2)
                }
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(.white)
                .padding(.leading, 16)

                Spacer(minLength: 0)

                Button {
                    onUpgradeTap?()
                } label: {
                    Text(AppStrings.Settings.upgradeNow)
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(AppColors.mainBlack)
                        .padding(.horizontal, 12)
                        .frame(height: 30)
                        .background(Color.white, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.trailing, 12)
            }
        }
        .frame(height: 70)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
