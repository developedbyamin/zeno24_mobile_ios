import SwiftUI

/// Toast / overlay banner state — mirrors overlay_helper.dart.
/// The visual is rendered by `OverlayBanner` mounted at the root.
@MainActor
@Observable
final class OverlayHelper {
    static let shared = OverlayHelper()

    enum Kind: Equatable {
        case success, error, warning, info

        var accent: Color {
            switch self {
            case .success: return Color(hex: 0x3DC562)
            case .error:   return Color(hex: 0xF70505)
            case .warning: return Color(hex: 0xFF5F03)
            case .info:    return Color(hex: 0x0A84FF)
            }
        }

        var systemImage: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error:   return "xmark.circle.fill"
            case .warning: return "exclamationmark.circle.fill"
            case .info:    return "info.circle.fill"
            }
        }
    }

    /// Bumped on every `show()` so the same message + kind still triggers
    /// the SwiftUI transition. View observes this value via the message id.
    private(set) var current: Message?

    struct Message: Identifiable, Equatable {
        let id: UUID
        let kind: Kind
        let text: String
    }

    private var dismissTask: Task<Void, Never>?

    private init() {}

    func show(_ text: String, kind: Kind = .info, duration: TimeInterval = 3) {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        dismissTask?.cancel()
        current = Message(id: UUID(), kind: kind, text: trimmed)

        dismissTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            self?.hide()
        }
    }

    func showFailure(_ error: Error, duration: TimeInterval = 3) {
        // Match overlay_helper.dart `showFailure` — backend errors with a
        // non-empty description take priority; other errors fall back to
        // `localizedDescription`.
        if let api = error as? APIError, case .backend(_, let desc) = api {
            guard let desc, !desc.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            show(desc, kind: .error, duration: duration)
            return
        }
        show(error.localizedDescription, kind: .error, duration: duration)
    }

    func hide() {
        dismissTask?.cancel()
        dismissTask = nil
        current = nil
    }
}
