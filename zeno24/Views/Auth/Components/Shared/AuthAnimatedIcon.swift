import SwiftUI

/// 81×81 glass square holding an animated emoji image —
/// Figma node `1829:2779`. Cross-fades when the source changes
/// (envelope ⇄ phone when the user toggles modes).
struct AuthAnimatedIcon: View {
    enum Source: Equatable, Hashable {
        case asset(String)
        case symbol(String)
        case emoji(String)
    }

    let source: Source
    var size: CGFloat = 81
    var cornerRadius: CGFloat = 26

    var body: some View {
        GlassFrame(cornerRadius: cornerRadius) {
            ZStack {
                content
                    .id(source)
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
            }
            .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
        .animation(.smooth(duration: 0.45), value: source)
    }

    @ViewBuilder
    private var content: some View {
        switch source {
        case .asset(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        case .symbol(let name):
            Image(systemName: name)
                .font(.system(size: size * 0.55, weight: .regular))
                .foregroundStyle(.white)
        case .emoji(let glyph):
            Text(glyph)
                .font(.system(size: size * 0.6))
        }
    }
}
