import SwiftUI

struct PremiumOutcomeDialog: View {
    enum Variant { case success, error }

    @Binding var isPresented: Bool
    let variant: Variant
    var onTryAgain: () -> Void = {}

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { dismiss() }

            VStack {
                Spacer(minLength: 0)
                card
                    .padding(.horizontal, 12)
                    .padding(.bottom, 24)
            }
        }
        .transition(.opacity)
    }

    // MARK: - Card

    private var card: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Image(emojiAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 166, height: 166)

                Text(title)
                    .font(AppTypography.bodyLgSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                Spacer().frame(height: 8)

                Text(subtitle)
                    .font(AppTypography.bodySmMedium)
                    .foregroundStyle(Color(hex: 0x8B98A8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                Spacer().frame(height: 24)

                Button(action: ctaTapped) {
                    Text(ctaTitle)
                        .font(AppTypography.bodySmBold)
                        .foregroundStyle(ctaTextColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(ctaBackground, in: Capsule())
                }
                .buttonStyle(OutcomePressStyle())
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }

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
                    .overlay(
                        Circle().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 1)
                    )
            }
            .buttonStyle(OutcomePressStyle())
            .padding(.top, 16)
            .padding(.trailing, 16)
        }
        .background(Color.white, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .onTapGesture { }
    }

    // MARK: - Variant content

    private var emojiAsset: String {
        switch variant {
        case .success: return AppImages.emojiCrown
        case .error:   return AppImages.emojiWarning3d
        }
    }

    private var title: String {
        switch variant {
        case .success: return "You\u{2019}re Premium Now! 🎉"
        case .error:   return "Something Went Wrong ☹\u{FE0F}"
        }
    }

    private var subtitle: String {
        switch variant {
        case .success: return "Enjoy full access to Premium features."
        case .error:   return "The payment couldn\u{2019}t be completed.\nPlease try again."
        }
    }

    private var ctaTitle: String {
        switch variant {
        case .success: return "Okay"
        case .error:   return "Try again"
        }
    }

    private var ctaTextColor: Color {
        switch variant {
        case .success: return AppColors.mainBlack
        case .error:   return .white
        }
    }

    private var ctaBackground: Color {
        switch variant {
        case .success: return Color(hex: 0xF2F5F9)
        case .error:   return AppColors.mainBlack
        }
    }

    // MARK: - Actions

    private func ctaTapped() {
        // Error CTA fires onTryAgain after dismissal, so the next dialog
        // can re-present cleanly without overlapping the closing one.
        let shouldTryAgain = variant == .error
        dismiss(invokeTryAgain: shouldTryAgain)
    }

    private func dismiss(invokeTryAgain: Bool = false) {
        withAnimation(.easeInOut(duration: 0.22)) {
            isPresented = false
        }
        if invokeTryAgain {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                onTryAgain()
            }
        }
    }
}

private struct OutcomePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
