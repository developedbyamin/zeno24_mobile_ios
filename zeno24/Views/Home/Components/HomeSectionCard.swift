import SwiftUI

struct HomeSectionCard<Content: View>: View {
    let scrollOffset: CGFloat
    let visibleHeight: CGFloat
    @Binding var contentHeight: CGFloat
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .frame(maxWidth: .infinity, alignment: .top)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SectionContentHeightKey.self, value: proxy.size.height)
                }
            )
            .onPreferenceChange(SectionContentHeightKey.self) { newHeight in
                guard abs(newHeight - contentHeight) > 0.5 else { return }
                contentHeight = newHeight
            }
            .offset(y: scrollOffset)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .frame(height: max(visibleHeight, 0), alignment: .top)
            .background(Color.white)
            .compositingGroup()
            .mask {
                UnevenRoundedRectangle(
                    cornerRadii: .init(topLeading: 24, topTrailing: 24)
                )
                .fill(Color.black)
            }
    }
}

private struct SectionContentHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
