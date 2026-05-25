import Foundation

@MainActor
@Observable
final class MarkersStore {
    var markers: [MarkerModel] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private let repository: MarkersRepository
    private var syncTask: Task<Void, Never>?

    init(repository: MarkersRepository? = nil) {
        self.repository = repository ?? ServiceLocator.shared.markersRepository
    }

    func startSyncing(interval: TimeInterval = 5) {
        syncTask?.cancel()
        syncTask = Task { [weak self] in
            while !Task.isCancelled {
                await self?.syncOnce()
                try? await Task.sleep(for: .seconds(interval))
            }
        }
    }

    func stopSyncing() {
        syncTask?.cancel()
        syncTask = nil
    }

    func syncOnce() async {
        do {
            markers = try await repository.fetchMarkers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
