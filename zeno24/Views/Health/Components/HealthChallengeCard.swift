import SwiftUI

struct HealthChallengeCard: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(AppStrings.Health.challengeBoard)
                    .font(AppTypography.bodyMdSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
                Spacer()
                Text(AppStrings.Health.inviteFriends)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(AppColors.brand)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(hex: 0xF8F7FF), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            VStack(spacing: 4) {
                row(avatar: AppImages.avatarFidan,  name: AppStrings.Health.memberFidan, score: "9.3", steps: "3,234", highlighted: false)
                row(avatar: AppImages.avatarChatMe, name: AppStrings.Health.memberYou,   score: "8.3", steps: "2,213", highlighted: true)
                row(avatar: AppImages.avatarFiruza, name: AppStrings.Health.memberFidan, score: "5.3", steps: "1,345", highlighted: false)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func row(avatar: String, name: String, score: String, steps: String, highlighted: Bool) -> some View {
        HStack {
            HStack(spacing: 10) {
                Image(avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {
                    Text(name)
                        .font(AppTypography.bodyMdBold)
                        .foregroundStyle(AppColors.mainBlack)
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: 0xFFCC00))
                        Text(score)
                            .font(AppTypography.bodyXsBold)
                            .foregroundStyle(Color(hex: 0x42474C))
                    }
                }
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 4) {
                    Image(AppImages.emojiRunning)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text(steps)
                        .font(AppTypography.bodyLgBold)
                        .foregroundStyle(AppColors.mainBlack)
                }
                Text(AppStrings.Health.todayLabel)
                    .font(AppTypography.bodyXsMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
        }
        .padding(.horizontal, highlighted ? 12 : 8)
        .padding(.vertical, 8)
        .background(highlighted ? Color(hex: 0xF8F7FF) : .clear,
                    in: RoundedRectangle(cornerRadius: highlighted ? 16 : 24, style: .continuous))
    }
}
