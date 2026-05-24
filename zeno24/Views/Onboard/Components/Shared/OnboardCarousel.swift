import SwiftUI

struct OnboardCarousel: View {
    let titles: [String]
    @State private var index = 0

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(titles.enumerated()), id: \.offset) { offset, title in
                VStack(spacing: 24) {
                    Spacer(minLength: 0)
                    Text(title)
                        .font(AppTypography.headingXsBold)
                        .tracking(0.5)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 323)
                    Color.clear.frame(height: 14)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .tag(offset)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            DotIndicator(count: titles.count, current: index)
                .frame(height: 14)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct DotIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(i == current ? 1.0 : 0.55))
                    .frame(width: i == current ? 10 : 8,
                           height: i == current ? 10 : 8)
                    .animation(.smooth(duration: 0.3), value: current)
            }
        }
    }
}
