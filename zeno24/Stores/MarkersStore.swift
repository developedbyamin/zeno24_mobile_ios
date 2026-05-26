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

    /// Idempotent: no-op if polling is already running. Lets the bootstrap
    /// flow kick off the long-running sync without stacking tasks on every
    /// re-entry into Home / navigation churn.
    func startSyncing(interval: TimeInterval = 20) {
        guard syncTask == nil else { return }
        syncTask = Task { [weak self] in
            // The bootstrap path already issued an immediate `syncOnce`, so
            // sleep first to avoid an instant duplicate request.
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                if Task.isCancelled { break }
                await self?.syncOnce()
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

    func reset() {
        stopSyncing()
        markers = []
        isLoading = false
        errorMessage = nil
    }
}
