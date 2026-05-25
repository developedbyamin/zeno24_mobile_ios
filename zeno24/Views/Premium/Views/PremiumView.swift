import SwiftUI

struct PremiumView: View {
    @State private var selectedPlan: Plan = .monthly
    @State private var isSubscribed: Bool = true
    @Environment(\.tabBarHeight) private var tabBarHeight

    private enum Plan { case monthly, yearly }

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
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                heroBanner

                if isSubscribed {
                    yourPlanCard
                    includedCard
                    cancelLink
                } else {
                    planRow
                    includedCard
                    bottomCTA
                }

                Color.clear.frame(height: tabBarHeight + 16)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color(hex: 0xF6F6F6).ignoresSafeArea())
        .navigationTitle(isSubscribed ? AppStrings.Premium.subscribedTitle : AppStrings.Premium.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero banner

    private var heroBanner: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0xAC4CC0), Color(hex: 0xEB6659)],
                startPoint: .leading,
                endPoint: .trailing
            )

            decorativeCircles

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(AppStrings.Premium.heroLine1)
                    Text(AppStrings.Premium.heroLine2)
                }
                .font(AppTypography.bodyLgBold)
                .foregroundStyle(.white)
                .lineSpacing(0)
                .padding(.leading, 16)

                Spacer(minLength: 0)

                Image(AppImages.emojiCrown)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 99, height: 99)
                    .rotationEffect(.degrees(-15))
                    .padding(.trailing, 8)
            }
        }
        .frame(height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var decorativeCircles: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    .frame(width: 95, height: 95)
                    .position(x: w - 30, y: -10)
                Circle()
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    .frame(width: 94, height: 94)
                    .position(x: w - 90, y: h + 8)
            }
            .allowsHitTesting(false)
        }
    }

    // MARK: - Plan row

    private var planRow: some View {
        HStack(alignment: .top, spacing: 12) {
            PlanCard(
                title: AppStrings.Premium.planPopular,
                price: AppStrings.Premium.planMonthlyPrice,
                caption: AppStrings.Premium.planMonthlyCaption,
                isSelected: selectedPlan == .monthly,
                priceGradient: Self.brandGradient
            )
            .onTapGesture { selectedPlan = .monthly }

            ZStack(alignment: .top) {
                PlanCard(
                    title: AppStrings.Premium.planBestValue,
                    price: AppStrings.Premium.planYearlyPrice,
                    caption: AppStrings.Premium.planYearlyCaption,
                    isSelected: selectedPlan == .yearly,
                    priceGradient: nil
                )
                .onTapGesture { selectedPlan = .yearly }

                saveBadge
                    .offset(y: -10)
            }
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

    // MARK: - Included card

    private var includedCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.Premium.includedHeader)
                .font(AppTypography.bodyXsBold)
                .foregroundStyle(AppColors.mainBlack.opacity(0.5))

            VStack(spacing: 12) {
                FeatureRow(asset: AppVectors.shieldDone,    title: AppStrings.Premium.featureParentalControl)
                divider
                FeatureRow(asset: AppVectors.diamondStar,   title: AppStrings.Premium.featureDrivingSafety)
                divider
                FeatureRow(asset: AppVectors.heartRate,     title: AppStrings.Premium.featureHealthGoals)
                divider
                FeatureRow(asset: AppVectors.newMassageDot, title: AppStrings.Premium.featurePlaceAlerts)
                divider
                FeatureRow(asset: AppVectors.circleClock,   title: AppStrings.Premium.featureLocationHistory)
                if isSubscribed {
                    divider
                    FeatureRow(asset: AppVectors.fire,      title: AppStrings.Premium.featureBonus)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var divider: some View {
        HStack {
            Spacer()
            Color(hex: 0xF2F5F9)
                .frame(width: 272, height: 1)
        }
    }

    // MARK: - Subscribed: your plan card

    private var yourPlanCard: some View {
        HStack(alignment: .bottom, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(AppStrings.Premium.yourPlanBadge)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .frame(height: 20)
                    .background(Self.brandGradient, in: Capsule())

                Text(AppStrings.Premium.planMonthlyPrice)
                    .font(AppTypography.headingXsBold)
                    .overlay(Self.brandGradient.mask(
                        Text(AppStrings.Premium.planMonthlyPrice).font(AppTypography.headingXsBold)
                    ))
                    .foregroundStyle(.clear)

                Text(AppStrings.Premium.planMonthlyCaption)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 0) {
                Button {
                } label: {
                    Text(AppStrings.Premium.managePlan)
                        .font(AppTypography.bodyXsBold)
                        .foregroundStyle(AppColors.mainBlack)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(hex: 0xFFE420), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .buttonStyle(.plain)

                Spacer(minLength: 0)

                HStack(spacing: 4) {
                    Image(AppVectors.timeCircle)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(AppStrings.Premium.untilDate("Mar 12, 2026"))
                        .font(AppTypography.bodyXsSemiBold)
                        .foregroundStyle(Color(hex: 0x8B98A8))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color(hex: 0xEB6659), lineWidth: 3)
        )
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 4, x: 0, y: 4)
    }

    // MARK: - Subscribed: cancel link

    private var cancelLink: some View {
        HStack {
            Spacer()
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isSubscribed = false
                }
            } label: {
                Text(AppStrings.Premium.cancelSubscription)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(Color(hex: 0x8B98A8))
                    .underline()
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }

    // MARK: - Bottom CTA

    private var bottomCTA: some View {
        VStack(spacing: 8) {
            Text(AppStrings.Premium.trialFootnote)
                .font(AppTypography.bodyXsMedium)
                .foregroundStyle(Color(hex: 0x292D32).opacity(0.5))

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isSubscribed = true
                }
            } label: {
                Text(AppStrings.Premium.cta)
                    .font(AppTypography.bodyMdBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(hex: 0xFFE420), in: Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Plan card

private struct PlanCard: View {
    let title: String
    let price: String
    let caption: String
    let isSelected: Bool
    let priceGradient: LinearGradient?

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(AppTypography.bodySmBold)
                .foregroundStyle(AppColors.mainBlack)

            priceLabel

            Text(caption)
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(AppColors.mainBlack)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color(hex: 0xEB6659), lineWidth: isSelected ? 3 : 0)
        )
        .shadow(color: isSelected ? Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1) : .clear,
                radius: 4, x: 0, y: 4)
    }

    @ViewBuilder
    private var priceLabel: some View {
        if let gradient = priceGradient {
            Text(price)
                .font(AppTypography.headingXsBold)
                .overlay(gradient.mask(Text(price).font(AppTypography.headingXsBold)))
                .foregroundStyle(.clear)
        } else {
            Text(price)
                .font(AppTypography.headingXsBold)
                .foregroundStyle(AppColors.mainBlack)
        }
    }
}

// MARK: - Feature row

private struct FeatureRow: View {
    let asset: String
    let title: String

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
        HStack(spacing: 10) {
            Image(asset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(Self.brandGradient)

            Text(title)
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            Spacer(minLength: 0)

            Image(systemName: "checkmark")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(hex: 0x3DC562))
                .frame(width: 24, height: 24)
        }
    }
}
