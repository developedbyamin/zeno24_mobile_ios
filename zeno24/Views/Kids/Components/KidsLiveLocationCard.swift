import SwiftUI

struct KidsLiveLocationCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            KidsCardHeader(title: AppStrings.Kids.liveLocation, action: AppStrings.Kids.details)

            ZStack(alignment: .topLeading) {
                Image(AppImages.kidsMap)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 164)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .background(Color(hex: 0xF6F7F9))

                Button {
                    // TODO: refresh
                } label: {
                    Image(AppVectors.refresh)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(AppColors.mainBlack)
                        .frame(width: 30, height: 30)
                        .background(Color.white, in: Circle())
                        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .buttonStyle(.plain)
                .padding(8)

                avatarPin
                    .position(x: 280, y: 50)

                addressCallout
                    .padding(.horizontal, 10)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 164)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var avatarPin: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 48, height: 48)
                .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 8, x: 0, y: 4)
            Image(AppImages.avatarFidan)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
        }
    }

    private var addressCallout: some View {
        HStack(spacing: 8) {
            Image(AppVectors.locationPin)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(AppColors.brand)
                .frame(width: 30, height: 30)
                .background(Color(hex: 0xF2F5F9), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(AppStrings.Kids.liveAddress)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text(AppStrings.Kids.liveSince)
                    .font(AppTypography.bodyXsMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }

            Spacer(minLength: 0)
        }
        .padding(.leading, 8)
        .padding(.trailing, 12)
        .padding(.vertical, 8)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
