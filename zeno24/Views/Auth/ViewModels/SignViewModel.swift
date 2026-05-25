import SwiftUI

@MainActor
@Observable
final class SignViewModel {
    var didAppear = false

    func onAppear(store: AuthStore) async {
        await Task.yield()
        didAppear = true
        try? await Task.sleep(for: .milliseconds(450))
    }
}
