import Foundation

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
            if let serverSelected = circles.first(where: { $0.isCurrent })?.id {
                selectedCircleId = serverSelected
            } else if selectedCircleId == nil {
                selectedCircleId = circles.first?.id
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

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

    func invite(circleId: String, role: String? = nil) async throws -> InviteCircleResponseModel {
        try await repository.invite(circleId: circleId, role: role)
    }
}
