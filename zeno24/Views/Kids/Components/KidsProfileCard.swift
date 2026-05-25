import SwiftUI

struct KidsProfileCard: View {
    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                Image(AppImages.avatarFidan)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())

                HStack(spacing: 4) {
                    Image(AppVectors.chargeBattery)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(Color(hex: 0x3DC562))
                    Text("12%")
                        .font(AppTypography.body2XsBold)
                        .foregroundStyle(Color(hex: 0x3DC562))
                }
                .padding(.horizontal, 6)
                .frame(height: 20)
                .background(
                    Capsule().fill(Color.white).overlay(Capsule().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 2))
                )
                .offset(x: -2, y: 8)
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(AppStrings.Kids.deviceName)
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text(AppStrings.Kids.deviceOwner)
                    .font(AppTypography.bodyXsMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                // TODO: add user
            } label: {
                Image(AppVectors.addUser)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(AppColors.brand)
                    .frame(width: 36, height: 36)
                    .background(Color(hex: 0xF8F7FF), in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
