import SwiftUI
import UIKit

struct OnboardSocialButton: View {
    private struct BackdropBlur: UIViewRepresentable {
        var style: UIBlurEffect.Style = .systemUltraThinMaterialDark

        func makeUIView(context: Context) -> UIVisualEffectView {
            UIVisualEffectView(effect: UIBlurEffect(style: style))
        }
        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
    }

    enum Provider {
        case apple, google

        var vectorAsset: String {
            switch self {
            case .apple:  return AppVectors.appleLogo
            case .google: return AppVectors.googleLogo
            }
        }

        var label: String {
            switch self {
            case .apple:  return AppStrings.Auth.Social.apple
            case .google: return AppStrings.Auth.Social.google
            }
        }

        var isTemplate: Bool {
            switch self {
            case .apple:  return true
            case .google: return false
            }
        }
    }

    let provider: Provider
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button {
            Haptics.selection()
            action()
        } label: {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    icon
                    Text(provider.label)
                        .font(AppTypography.bodySmSemiBold)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background {
                ZStack {
                    BackdropBlur(style: .systemUltraThinMaterialDark)
                    Color.white.opacity(0.24)
                }
                .clipShape(Capsule())
            }
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }

    @ViewBuilder
    private var icon: some View {
        if provider.isTemplate {
            Image(provider.vectorAsset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)
        } else {
            Image(provider.vectorAsset)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
    }
}
