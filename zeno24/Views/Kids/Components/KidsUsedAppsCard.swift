import SwiftUI

struct KidsUsedAppsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            KidsCardHeader(title: AppStrings.Kids.usedApps, action: AppStrings.Kids.details)

            VStack(spacing: 12) {
                UsedAppRow(asset: AppImages.appPubg,       title: AppStrings.Kids.appPubg,      time: AppStrings.Kids.appPubgTime,      isOn: true)
                divider
                UsedAppRow(asset: AppVectors.appTiktok,    title: AppStrings.Kids.appTiktok,    time: AppStrings.Kids.appTiktokTime,    isOn: true)
                divider
                UsedAppRow(asset: AppVectors.appYoutube,   title: AppStrings.Kids.appYoutube,   time: AppStrings.Kids.appYoutubeTime,   isOn: false)
                divider
                UsedAppRow(asset: AppVectors.appInstagram, title: AppStrings.Kids.appInstagram, time: AppStrings.Kids.appInstagramTime, isOn: false)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var divider: some View {
        HStack {
            Spacer()
            Color(hex: 0xF2F5F9).frame(height: 1)
            Spacer()
        }
        .frame(width: 283, height: 1)
    }
}

private struct UsedAppRow: View {
    let asset: String
    let title: String
    let time: String
    @State var isOn: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(asset)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .frame(width: 40, height: 40)
                .background(Color(hex: 0xF8F7FF), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppTypography.bodySmSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
                Text(time)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppColors.brand)

            Image(AppVectors.arrowRight)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundStyle(Color(hex: 0x8B98A8))
                .frame(width: 24, height: 24)
                .background(Color(hex: 0xF2F5F9), in: Circle())
        }
    }
}
