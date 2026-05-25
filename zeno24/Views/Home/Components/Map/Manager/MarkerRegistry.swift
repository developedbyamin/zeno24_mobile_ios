import Foundation

final class MarkerRegistry {

    var markers: [String: MarkerInfo] = [:]

    var ids: [String] = []
    var infos: [MarkerInfo] = []

    var size: Int { markers.count }

    func has(_ id: String) -> Bool { markers[id] != nil }
    func get(_ id: String) -> MarkerInfo? { markers[id] }
    func allIds() -> [String] { Array(markers.keys) }

    @discardableResult
    func add(id: String, info: MarkerInfo) -> MarkerInfo? {
        let previous = markers[id]
        markers[id] = info
        rebuild()
        return previous
    }

    @discardableResult
    func remove(_ id: String) -> MarkerInfo? {
        guard let removed = markers.removeValue(forKey: id) else { return nil }
        rebuild()
        return removed
    }

    func clear() {
        markers.removeAll(keepingCapacity: true)
        ids.removeAll(keepingCapacity: true)
        infos.removeAll(keepingCapacity: true)
    }

    func rebuild() {
        ids.removeAll(keepingCapacity: true)
        infos.removeAll(keepingCapacity: true)
        for (k, v) in markers {
            ids.append(k)
            infos.append(v)
        }
    }
}
