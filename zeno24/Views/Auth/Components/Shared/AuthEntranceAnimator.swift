import SwiftUI

/// Staggered entrance shared by all auth screens.
/// Each step starts 60 ms after the previous one, runs for 320 ms,
/// and combines a 12-px upward slide with an opacity fade.
///
/// Usage:
///     @State private var didAppear = false
///
///     content
///         .authEntrance(.header, isVisible: didAppear)
///         .authEntrance(.icon,   isVisible: didAppear)
///         …
///         .onAppear { didAppear = true }
enum AuthEntranceStep: Double, CaseIterable {
    case header = 0.00
    case icon   = 0.06
    case title  = 0.12
    case input  = 0.18
    case toggle = 0.24
    case action = 0.30

    var delay: Double { rawValue }
}

private struct AuthEntranceModifier: ViewModifier {
    let step: AuthEntranceStep
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 12)
            .animation(
                .easeOut(duration: 0.32).delay(isVisible ? step.delay : 0),
                value: isVisible
            )
    }
}

extension View {
    func authEntrance(_ step: AuthEntranceStep, isVisible: Bool) -> some View {
        modifier(AuthEntranceModifier(step: step, isVisible: isVisible))
    }
}
