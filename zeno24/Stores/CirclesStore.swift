import Foundation

/// Circles list + selection state — mirrors circles_provider.dart
@MainActor
@Observable
final class CirclesStore {
    var circles: [CircleModel] = []
    var selectedCircleId: String?
    var isLoading: Bool = false
    var errorMessage: String?

    private let repository: CirclesRepository

    init(repository: CirclesRepository? = nil) {
        self.repository = repository ?? ServiceLocator.shared.circlesRepository
    }

    var selectedCircle: CircleModel? {
        circles.first { $0.id == selectedCircleId }
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            circles = try await repository.list()
            // Backend marks the active circle with `current = 1`; fall back to
            // the first item so the UI always shows a selection.
            if let serverSelected = circles.first(where: { $0.isCurrent })?.id {
                selectedCircleId = serverSelected
            } else if selectedCircleId == nil {
                selectedCircleId = circles.first?.id
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Throws so callers can surface the real `Error` (e.g. `APIError.backend`)
    /// via `OverlayHelper.showFailure(_:)`.
    @discardableResult
    func add(name: String) async throws -> CircleModel {
        errorMessage = nil
        do {
            let circle = try await repository.add(name: name)
            circles.insert(circle, at: 0)
            selectedCircleId = circle.id
            return circle
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }

    func switchTo(_ id: String) async {
        selectedCircleId = id
        try? await repository.switchTo(circleId: id)
    }

    /// Throws so the calling sheet can surface API errors via `OverlayHelper`.
    func invite(circleId: String, role: String? = nil) async throws -> InviteCircleResponseModel {
        try await repository.invite(circleId: circleId, role: role)
    }
}
