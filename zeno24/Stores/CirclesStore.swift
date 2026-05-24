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
            if selectedCircleId == nil { selectedCircleId = circles.first?.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func add(name: String) async {
        do {
            let circle = try await repository.add(name: name)
            circles.insert(circle, at: 0)
            selectedCircleId = circle.id
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func switchTo(_ id: String) async {
        selectedCircleId = id
        try? await repository.switchTo(circleId: id)
    }
}
