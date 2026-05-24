import SwiftUI

/// Top-of-screen toast — visual mirror of `_AnimatedOverlay` from
/// `overlay_helper.dart`. Pinned to the safe-area top, slides in + fades.
/// Mount once at the app root and let `OverlayHelper.shared` drive it.
struct OverlayBanner: View {
    private var overlay: OverlayHelper { OverlayHelper.shared }

    var body: some View {
        VStack(spacing: 0) {
            if let message = overlay.current {
                pill(for: message)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .onTapGesture { overlay.hide() }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .id(message.id)
            }
            Spacer(minLength: 0)
        }
        .animation(.easeOut(duration: 0.32), value: overlay.current?.id)
        .allowsHitTesting(overlay.current != nil)
    }

    @ViewBuilder
    private func pill(for message: OverlayHelper.Message) -> some View {
        HStack(spacing: 8) {
            Image(systemName: message.kind.systemImage)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(message.kind.accent)

            Text(message.text)
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(message.kind.accent)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.leading, 12)
        .padding(.trailing, 18)
        .padding(.vertical, 8)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview("Error") {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()
        OverlayBanner()
    }
    .task {
        OverlayHelper.shared.show("Country is wrong", kind: .error, duration: 60)
    }
}
