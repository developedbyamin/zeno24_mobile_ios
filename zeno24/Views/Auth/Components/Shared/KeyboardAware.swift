import SwiftUI
import Combine

/// Observable wrapper around the system keyboard frame. Vends the
/// current keyboard height as an `@Observable` so SwiftUI views can
/// resize their content (instead of letting SwiftUI's default
/// auto-lift heuristics drag the whole layer up).
@MainActor
@Observable
final class KeyboardObserver {
    var height: CGFloat = 0

    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

    init() {
        let show = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }

        let hide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        show.merge(with: hide)
            .receive(on: RunLoop.main)
            .sink { [weak self] h in self?.height = h }
            .store(in: &cancellables)
    }
}

// MARK: - View modifier sugar

extension View {
    /// Reads the keyboard height into the supplied binding, kept in
    /// sync as the keyboard shows, resizes (e.g. predictive bar
    /// appears), or hides.
    ///
    /// Prefer this over hand-rolled NotificationCenter publishers in
    /// every view — it keeps the observer's lifecycle tied to the
    /// modifier and exposes a plain `CGFloat` for layout maths.
    func keyboardHeight(_ height: Binding<CGFloat>) -> some View {
        modifier(KeyboardHeightReader(height: height))
    }
}

private struct KeyboardHeightReader: ViewModifier {
    @Binding var height: CGFloat
    @State private var observer = KeyboardObserver()

    func body(content: Content) -> some View {
        content
            .onChange(of: observer.height, initial: true) { _, new in
                height = new
            }
    }
}
