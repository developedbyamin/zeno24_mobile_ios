import SwiftUI

struct OnboardTermsText: View {
    var onPrivacyTap: () -> Void = {}
    var onTermsTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 2) {
            Text(AppStrings.Onboard.Terms.prefix)
                .font(AppTypography.bodyXsRegular)
                .foregroundStyle(.white.opacity(0.5))

            Text(makeBottomLine())
                .font(AppTypography.bodyXsRegular)
                .environment(\.openURL, OpenURLAction { url in
                    switch url.absoluteString {
                    case "zeno24://privacy": onPrivacyTap()
                    case "zeno24://terms":   onTermsTap()
                    default: break
                    }
                    return .handled
                })
        }
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }

    private func makeBottomLine() -> AttributedString {
        var privacy = AttributedString(AppStrings.Onboard.Terms.privacy)
        privacy.foregroundColor = .white
        privacy.underlineStyle = .single
        privacy.font = AppTypography.bodyXsMedium
        privacy.link = URL(string: "zeno24://privacy")

        var separator = AttributedString(AppStrings.Onboard.Terms.and)
        separator.foregroundColor = .white.opacity(0.5)
        separator.font = AppTypography.bodyXsRegular

        var terms = AttributedString(AppStrings.Onboard.Terms.service)
        terms.foregroundColor = .white
        terms.underlineStyle = .single
        terms.font = AppTypography.bodyXsMedium
        terms.link = URL(string: "zeno24://terms")

        var result = privacy
        result.append(separator)
        result.append(terms)
        return result
    }
}
