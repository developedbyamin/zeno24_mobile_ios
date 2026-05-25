import SwiftUI

struct HomePlacesContent: View {
    var onInviteCircle: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            inviteCircleRow

            VStack(alignment: .leading, spacing: 12) {
                Text(AppStrings.Home.placesTitle)
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(AppColors.mainBlack)
                managePlacesRow
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Invite circle row

    private var inviteCircleRow: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer().frame(width: 66)
                Rectangle()
                    .fill(Color(hex: 0xF2F5F9))
                    .frame(height: 1)
                Spacer().frame(width: 24)
            }
            .padding(.top, 8)

            Button {
                Haptics.selection()
                onInviteCircle?()
            } label: {
                HStack(spacing: 10) {
                    SquareIcon(asset: AppVectors.members)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(AppStrings.Home.expandCircle)
                            .font(AppTypography.bodySmBold)
                            .foregroundStyle(AppColors.brand)
                        Text(AppStrings.Home.inviteNewMember)
                            .font(AppTypography.bodyXsMedium)
                            .foregroundStyle(Color(hex: 0x8B98A8))
                    }
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(hex: 0x8B98A8))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 5)
            }
            .buttonStyle(.plain)
            .padding(.top, 8)
        }
    }

    // MARK: - Manage places row

    private var managePlacesRow: some View {
        HStack(spacing: 12) {
            SquareIcon(asset: AppVectors.earth)
            VStack(alignment: .leading, spacing: 6) {
                Text(AppStrings.Home.managePlaces)
                    .font(AppTypography.bodySmBold)
                    .foregroundStyle(AppColors.brand)
                Text(AppStrings.Home.managePlacesSubtitle)
                    .font(AppTypography.bodyXsRegular)
                    .foregroundStyle(Color(hex: 0x8B98A8))
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(hex: 0x8B98A8))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Shared rounded brand-tinted icon

struct SquareIcon: View {
    let asset: String

    var body: some View {
        Image(asset)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundStyle(AppColors.brand)
            .frame(width: 48, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(hex: 0xF8F7FF))
            )
    }
}
