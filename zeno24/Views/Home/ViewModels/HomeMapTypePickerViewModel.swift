import SwiftUI

@MainActor
@Observable
final class HomeMapTypePickerViewModel {
    var dragOffset: CGFloat = 0
    var visible = false

    func appear() {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.92)) {
            visible = true
        }
    }

    func onDragChanged(_ translation: CGFloat) {
        dragOffset = max(0, translation)
    }

    func onDragEnded(predictedEnd: CGFloat, dismiss: () -> Void) {
        let projected = dragOffset + predictedEnd * 0.18
        if projected > 120 {
            dismiss()
        } else {
            withAnimation(.spring(response: 0.24, dampingFraction: 0.92)) {
                dragOffset = 0
            }
        }
    }

    func dismiss(completion: @escaping () -> Void) {
        withAnimation(.easeIn(duration: 0.24)) {
            visible = false
            dragOffset = 0
        }
        Task {
            try? await Task.sleep(for: .milliseconds(250))
            completion()
        }
    }
}
