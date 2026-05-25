import SwiftUI

struct PremiumSheet: View {
    @Binding var isPresented: Bool
    var onStartTrial: (Plan) -> Void = { _ in }

    enum Plan: String { case monthly, yearly }

    var body: some View {
        BottomSheetContainer(
            isPresented: $isPresented,
            topCornerRadius: 30,
            panelFill: Color(hex: 0xF6F6F6)
        ) { dismiss in
            PremiumPanel(dismiss: dismiss, onStartTrial: onStartTrial)
        }
    }
}

// MARK: - Panel

private struct PremiumPanel: View {
    let dismiss: BottomSheetDismissAction
    let onStartTrial: (PremiumSheet.Plan) -> Void

    @State private var selected: PremiumSheet.Plan = .monthly

    private static let brandGradient = LinearGradient(
        colors: [
            Color(hex: 0xEB6659),
            Color(hex: 0xAC4CC0),
            Color(hex: 0x9171F4),
        ],
        startPoint: .trailing,
        endPoint: .leading
    )

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.top, 16)

            Spacer().frame(height: 26)

            cardsRow
                .padding(.horizontal, 16)

            Spacer().frame(height: 16)

            featuresCard
                .padding(.horizontal, 16)

            Spacer().frame(height: 16)

            Text(AppStrings.Premium.trialFootnote)
                .font(AppTypography.bodyXsMedium)
                .foregroundStyle(AppColors.secondaryBlack.opacity(0.5))
                .padding(.horizontal, 26)

            Spacer().frame(height: 8)

            ctaButton
                .padding(.horizontal, 16)

            Spacer().frame(height: 34)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(AppVectors.closeSmall)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(AppColors.mainBlack)
                    .frame(width: 32, height: 32)
                    .background(Color.white, in: Circle())
            }
            .buttonStyle(PremiumPressStyle())

            Spacer()

            Text(AppStrings.Premium.title)
                .font(AppTypography.bodyLgSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            Spacer()

            Color.clear.frame(width: 32, height: 32)
        }
        .frame(height: 40)
    }

    // MARK: - Plan cards

    private var cardsRow: some View {
        HStack(alignment: .top, spacing: 12) {
            planCard(
                title: AppStrings.Premium.planPopular,
                price: AppStrings.Premium.planMonthlyPrice,
                caption: AppStrings.Premium.planMonthlyCaption,
                plan: .monthly
            )

            ZStack(alignment: .top) {
                planCard(
                    title: AppStrings.Premium.planBestValue,
                    price: AppStrings.Premium.planYearlyPrice,
                    caption: AppStrings.Premium.planYearlyCaption,
                    plan: .yearly
                )

                saveBadge
                    .offset(y: -10)
            }
        }
    }

    private func planCard(
        title: String,
        price: String,
        caption: String,
        plan: PremiumSheet.Plan
    ) -> some View {
        let isSelected = selected == plan
        return VStack(spacing: 8) {
            Text(title)
                .font(AppTypography.bodySmBold)
                .foregroundStyle(AppColors.mainBlack)

            if isSelected {
                Text(price)
                    .font(AppTypography.headingXsBold)
                    .overlay(Self.brandGradient.mask(
                        Text(price).font(AppTypography.headingXsBold)
                    ))
                    .foregroundStyle(.clear)
            } else {
                Text(price)
                    .font(AppTypography.headingXsBold)
                    .foregroundStyle(AppColors.mainBlack)
            }

            Text(caption)
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(AppColors.mainBlack)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 8)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            // Brand gradient stroke when selected — UIKit reference uses a
            // 3pt stroke. The double-overlay (clear fill + gradient stroke)
            // matches the original CAGradientLayer mask trick.
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.clear, lineWidth: isSelected ? 3 : 0)
                .background(
                    Group {
                        if isSelected {
                            Self.brandGradient
                                .mask(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .strokeBorder(lineWidth: 3)
                                )
                        }
                    }
                )
        )
        .shadow(
            color: Color(hex: 0x0C0C0D).opacity(isSelected ? 0.1 : 0.05),
            radius: isSelected ? 16 : 1,
            x: 0,
            y: isSelected ? 16 : 1
        )
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.18)) { selected = plan }
        }
    }

    private var saveBadge: some View {
        Text(AppStrings.Premium.planSaveBadge)
            .font(AppTypography.bodyXsBold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .frame(height: 20)
            .background(Self.brandGradient, in: Capsule())
    }

    // MARK: - Features card

    private struct Feature: Hashable {
        let asset: String
        let title: String
    }

    private var features: [Feature] {
        [
            Feature(asset: AppVectors.shieldDone,    title: AppStrings.Premium.featureParentalControl),
            Feature(asset: AppVectors.diamondStar,   title: AppStrings.Premium.featureDrivingSafety),
            Feature(asset: AppVectors.heartRate,     title: AppStrings.Premium.featureHealthGoals),
            Feature(asset: AppVectors.newMassageDot, title: AppStrings.Premium.featurePlaceAlerts),
            Feature(asset: AppVectors.circleClock,   title: AppStrings.Premium.featureLocationHistory),
            Feature(asset: AppVectors.fire,          title: AppStrings.Premium.featureBonus),
        ]
    }

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.Premium.includedHeader)
                .font(AppTypography.bodyXsBold)
                .foregroundStyle(AppColors.mainBlack.opacity(0.5))
                .tracking(0.6)

            VStack(spacing: 0) {
                ForEach(Array(features.enumerated()), id: \.element) { index, feature in
                    if index > 0 {
                        // 38pt left inset divider so it starts after the icon column.
                        HStack {
                            Spacer().frame(width: 38)
                            Rectangle()
                                .fill(Color(hex: 0xF2F5F9))
                                .frame(height: 1)
                        }
                        .frame(height: 25)
                    }
                    featureRow(feature)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color(hex: 0x0C0C0D).opacity(0.05), radius: 2, x: 0, y: 1)
    }

    private func featureRow(_ feature: Feature) -> some View {
        HStack(spacing: 10) {
            Image(feature.asset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(Self.brandGradient)

            Text(feature.title)
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            Spacer(minLength: 8)

            Image(systemName: "checkmark")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(hex: 0x3DC562))
                .frame(width: 24, height: 24)
        }
        .frame(height: 28)
    }

    // MARK: - CTA

    private var ctaButton: some View {
        Button {
            let plan = selected
            dismiss { onStartTrial(plan) }
        } label: {
            Text(AppStrings.Premium.cta)
                .font(AppTypography.bodyMdBold)
                .foregroundStyle(AppColors.mainBlack)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color(hex: 0xFFE420), in: Capsule())
        }
        .buttonStyle(PremiumPressStyle())
    }
}

// MARK: - Press style

private struct PremiumPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
