import SwiftUI

@MainActor
@Observable
final class ModalService {
    static let shared = ModalService()

    var activeSheet: AnyView?
    var alertTitle: String?
    var alertMessage: String?

    func showSheet<Content: View>(@ViewBuilder _ content: () -> Content) {
        activeSheet = AnyView(content())
    }

    func dismiss() {
        activeSheet = nil
    }

    func showAlert(title: String, message: String? = nil) {
        alertTitle = title
        alertMessage = message
    }
}
