import SwiftUI
import Combine

@MainActor
@Observable
final class KeyboardObserver {
    var height: CGFloat = 0

    private var cancellables = Set<AnyCancellable>()

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
