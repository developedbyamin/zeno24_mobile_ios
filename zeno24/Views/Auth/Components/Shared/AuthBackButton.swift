import SwiftUI

/// 36×36 glass square with a back-arrow vector — Figma node `3714:6402`.
struct AuthBackButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            Haptics.selection()
            action()
        } label: {
            GlassFrame(cornerRadius: 14) {
                Image(AppVectors.backArrow)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
            }
            .frame(width: 36, height: 36)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(AppStrings.Common.back))
    }
}
