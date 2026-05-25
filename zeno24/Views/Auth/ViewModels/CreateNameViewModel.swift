import SwiftUI

@MainActor
@Observable
final class CreateNameViewModel {
    var didAppear = false

    func onAppear() async {
        await Task.yield()
        didAppear = true
        try? await Task.sleep(for: .milliseconds(400))
    }
}
