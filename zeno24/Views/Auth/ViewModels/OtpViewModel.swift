import SwiftUI

@MainActor
@Observable
final class OtpViewModel {
    var didAppear = false
    var countdown = OtpCountdown(seconds: 0)

    let resendCooldown = 120

    func onAppear() async {
        await Task.yield()
        didAppear = true
        try? await Task.sleep(for: .milliseconds(400))
    }

    func startCountdown() {
        countdown.start(from: resendCooldown)
    }

    func stopCountdown() {
        countdown.stop()
    }
}
