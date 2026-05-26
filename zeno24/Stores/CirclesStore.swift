import Foundation

@MainActor
@Observable
final class CirclesStore {
    var circles: [CircleModel] = []
    var selectedCircleId: String?
    var isLoading: Bool = false
    var errorMessage: String?
    var hasLoaded: Bool = false

    private let repository: CirclesRepository

    init(repository: CirclesRepository? = nil) {
        self.repository = repository ?? ServiceLocator.shared.circlesRepository
    }

    var selectedCircle: CircleModel? {
        circles.first { $0.id == selectedCircleId }
    }

    func reset() {
        circles = []
        selectedCircleId = nil
        isLoading = false
        errorMessage = nil
        hasLoaded = false
    }

    func load() async {
        guard !hasLoaded, !isLoading else { return }
        await reload()
    }

    func reload() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            circles = try await repository.list()
            if let serverSelected = circles.first(where: { $0.isCurrent })?.id {
                selectedCircleId = serverSelected
            } else if selectedCircleId == nil {
                selectedCircleId = circles.first?.id
            }
            hasLoaded = true
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

    func info(code: String) async throws -> InfoCircleResponseModel {
        try await repository.info(code: code)
    }

    @discardableResult
    func join(code: String) async throws -> CircleModel {
        errorMessage = nil
        let joined = try await repository.join(code: code)
        if let idx = circles.firstIndex(where: { $0.id == joined.id }) {
            circles[idx] = joined
        } else {
            circles.insert(joined, at: 0)
        }
        selectedCircleId = joined.id
        return joined
    }
}
