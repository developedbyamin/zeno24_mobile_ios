import SwiftUI

// MARK: - Auth text field

struct AuthTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTypography.headingXsSemiBold)
            .foregroundStyle(.white)
            .tint(.white)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

extension View {
    func authTextField() -> some View { modifier(AuthTextFieldStyle()) }
}

// MARK: - Placeholder overlay helper

// Draws a white/54 placeholder *behind* a TextField when its bound value is
// empty — the only reliable way to control placeholder colour independently
// of `prompt:` on current iOS.
struct AuthPlaceholder: ViewModifier {
    let placeholder: String
    let isEmpty: Bool
    var alignment: HorizontalAlignment = .center

    func body(content: Content) -> some View {
        ZStack(alignment: zstackAlignment) {
            if isEmpty {
                Text(placeholder)
                    .font(AppTypography.headingXsSemiBold)
                    .foregroundStyle(Color.white.opacity(0.54))
                    .allowsHitTesting(false)
            }
            content
        }
    }

    private var zstackAlignment: Alignment {
        switch alignment {
        case .leading:  return .leading
        case .trailing: return .trailing
        default:        return .center
        }
    }
}

extension View {
    func authPlaceholder(_ text: String,
                        when isEmpty: Bool,
                        alignment: HorizontalAlignment = .center) -> some View {
        modifier(AuthPlaceholder(placeholder: text, isEmpty: isEmpty, alignment: alignment))
    }
}

// MARK: - Default themed TextField (light/dark surface)

struct ThemedTextFieldStyle: ViewModifier {
    @Environment(\.appTheme) private var theme

    func body(content: Content) -> some View {
        content
            .font(theme.typography.bodyLg)
            .foregroundStyle(theme.palette.labelPrimary)
            .tint(theme.palette.brand)
            .padding(.horizontal, 14)
            .frame(minHeight: 48)
            .background(theme.palette.surface,
                        in: RoundedRectangle(cornerRadius: theme.radius.medium, style: .continuous))
    }
}

extension View {
    func themedTextField() -> some View { modifier(ThemedTextFieldStyle()) }
}
