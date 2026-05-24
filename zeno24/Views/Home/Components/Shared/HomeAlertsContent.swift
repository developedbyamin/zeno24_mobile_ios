import SwiftUI

/// Alerts tab content — Flutter iOS UIKit `HomeAlertsPanel`.
/// "Alerts & notifications" header, 5 toggle rows, then the Premium
/// promo card with gradient text and feature bullets.
struct HomeAlertsContent: View {
    @State private var placeAlerts = false
    @State private var startOfMovement = true
    @State private var endOfMovement = true
    @State private var safeDrive = false
    @State private var lowBattery = false

    var onPremiumTap: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.Home.alertsHeader)
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            VStack(spacing: 12) {
                AlertToggleRow(asset: AppVectors.pin,
                               title: AppStrings.Home.alertPlaceAlerts,
                               isOn: $placeAlerts)
                AlertToggleRow(asset: AppVectors.turnRight,
                               title: AppStrings.Home.alertStartMovement,
                               isOn: $startOfMovement)
                AlertToggleRow(asset: AppVectors.turnLeft,
                               title: AppStrings.Home.alertEndMovement,
                               isOn: $endOfMovement)
                AlertToggleRow(asset: AppVectors.car,
                               title: AppStrings.Home.alertSafeDrive,
                               isOn: $safeDrive)
                AlertToggleRow(asset: AppVectors.lowBattery,
                               title: AppStrings.Home.alertLowBattery,
                               isOn: $lowBattery)
            }

            Spacer().frame(height: 16)

            PremiumPromoCard(onTap: onPremiumTap)
        }
        .padding(16)
    }
}

// MARK: - Alert toggle row

private struct AlertToggleRow: View {
    let asset: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(asset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(AppColors.brand)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(hex: 0xF8F7FF))
                )

            Text(title)
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(AppColors.mainBlack)
                .frame(maxWidth: .infinity, alignment: .leading)

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppColors.brand)
        }
        .frame(minHeight: 40)
    }
}

// MARK: - Premium promo card

private struct PremiumPromoCard: View {
    var onTap: (() -> Void)? = nil

    private let gradientColors: [Color] = [
        Color(hex: 0xEB6659),
        Color(hex: 0xAC4CC0),
        Color(hex: 0x9171F4),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top) {
                gradientText(AppStrings.Home.premiumTitle)
                    .font(AppTypography.heading2XlBold)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("👑")
                    .font(.system(size: 64))
                    .frame(width: 96, height: 96)
            }

            VStack(spacing: 24) {
                PremiumFeature(asset: AppVectors.shieldDone,
                               text: AppStrings.Home.premiumFeature1,
                               gradient: gradientColors)
                PremiumFeature(asset: AppVectors.heartRate,
                               text: AppStrings.Home.premiumFeature2,
                               gradient: gradientColors)
                PremiumFeature(asset: AppVectors.newMassageDot,
                               text: AppStrings.Home.premiumFeature3,
                               gradient: gradientColors)
                PremiumFeature(asset: AppVectors.circleClock,
                               text: AppStrings.Home.premiumFeature4,
                               gradient: gradientColors)
            }

            Button {
                Haptics.selection()
                onTap?()
            } label: {
                Text(AppStrings.Home.premiumCTA)
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(hex: 0xFFE420), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private func gradientText(_ text: String) -> some View {
        Text(text)
            .overlay(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .trailing,
                    endPoint: .leading
                )
                .mask(Text(text).font(AppTypography.heading2XlBold))
            )
            .foregroundStyle(.clear)
    }
}

private struct PremiumFeature: View {
    let asset: String
    let text: String
    let gradient: [Color]

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(asset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(.white)
                .overlay(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                    .mask(
                        Image(asset)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                    )
                )

            Text(text)
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(AppColors.mainBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
