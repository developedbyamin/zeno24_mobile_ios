import SwiftUI

/// Generic white card with rounded top corners that hosts a section's
/// content. Performs the same manual-scroll bookkeeping as the previous
/// `HomeMembersCard`: reports its `contentHeight` upward and lets the
/// parent drive `scrollOffset` from a unified drag gesture.
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
            .onPreferenceChange(SectionContentHeightKey.self) { contentHeight = $0 }
            .offset(y: scrollOffset)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .frame(height: max(visibleHeight, 0), alignment: .top)
            .background(Color.white)
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: .init(topLeading: 24, topTrailing: 24)
                )
            )
    }
}

private struct SectionContentHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
