import SwiftUI

@MainActor
@Observable
final class OtpCountdown {
    var remaining: Int
    private var task: Task<Void, Never>?

    init(seconds: Int) { self.remaining = seconds }

    func start(from seconds: Int) {
        task?.cancel()
        remaining = seconds
        task = Task { [weak self] in
            while !Task.isCancelled, let self, self.remaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { return }
                self.remaining -= 1
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    var formatted: String {
        let m = remaining / 60
        let s = remaining % 60
        return String(format: "%02d:%02d", m, s)
    }

    var isFinished: Bool { remaining == 0 }
}

struct OtpTimerPill: View {
    let formatted: String
    let isVisible: Bool

    var body: some View {
        Text(formatted)
            .font(AppTypography.bodySmSemiBold.monospacedDigit())
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .overlay(
                        Capsule().strokeBorder(Color.white.opacity(0.16), lineWidth: 1)
                    )
            )
            .opacity(isVisible ? 1 : 0)
            .animation(.easeOut(duration: 0.2), value: isVisible)
    }
}
