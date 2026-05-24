import UIKit

enum ClusterEngine {

    struct Input {
        let id: String
        let x: CGFloat
        let y: CGFloat
        let activitySinceMs: Int
    }

    struct Cluster {

        let id: String

        let memberIds: [String]

        let centerX: CGFloat
        let centerY: CGFloat

        var size: Int { memberIds.count }
        var isSolo: Bool { memberIds.count == 1 }
    }

    static func cluster(_ inputs: [Input], radiusPx: CGFloat) -> [Cluster] {
        if inputs.isEmpty { return [] }
        if inputs.count == 1 {
            let only = inputs[0]
            return [Cluster(id: only.id, memberIds: [only.id], centerX: only.x, centerY: only.y)]
        }

        let cellSize = radiusPx
        let r2 = radiusPx * radiusPx

        var grid: [Int64: [Int]] = [:]
        func key(_ col: Int32, _ row: Int32) -> Int64 {
            (Int64(col) & 0xFFFFFFFF) << 32 | (Int64(row) & 0xFFFFFFFF)
        }

        for i in 0..<inputs.count {
            let inp = inputs[i]
            let col = Int32(inp.x / cellSize)
            let row = Int32(inp.y / cellSize)
            let k = key(col, row)
            if grid[k] == nil { grid[k] = [] }
            grid[k]!.append(i)
        }

        var assignment = [Int](repeating: -1, count: inputs.count)
        var clusters: [[Int]] = []

        for i in 0..<inputs.count {
            if assignment[i] != -1 { continue }
            let seed = inputs[i]
            let clusterIdx = clusters.count
            var members: [Int] = [i]
            assignment[i] = clusterIdx

            let seedCol = Int32(seed.x / cellSize)
            let seedRow = Int32(seed.y / cellSize)
            for dc: Int32 in -1...1 {
                for dr: Int32 in -1...1 {
                    guard let bucket = grid[key(seedCol + dc, seedRow + dr)] else { continue }
                    for j in bucket {
                        if j == i || assignment[j] != -1 { continue }
                        let other = inputs[j]
                        let dx = other.x - seed.x
                        let dy = other.y - seed.y
                        if dx * dx + dy * dy <= r2 {
                            assignment[j] = clusterIdx
                            members.append(j)
                        }
                    }
                }
            }
            clusters.append(members)
        }

        var out: [Cluster] = []
        out.reserveCapacity(clusters.count)
        for members in clusters {
            if members.count == 1 {
                let inp = inputs[members[0]]
                out.append(Cluster(id: inp.id, memberIds: [inp.id], centerX: inp.x, centerY: inp.y))
                continue
            }

            let ids = members.map { inputs[$0].id }
            let sortedIds = ids.sorted()
            let clusterId = "cluster:" + sortedIds.joined(separator: "|")

            let orderedMembers = members
                .map { inputs[$0] }
                .sorted { $0.activitySinceMs > $1.activitySinceMs }
                .map { $0.id }

            var sx: CGFloat = 0
            var sy: CGFloat = 0
            for mi in members {
                sx += inputs[mi].x
                sy += inputs[mi].y
            }
            let n = CGFloat(members.count)
            out.append(Cluster(
                id: clusterId,
                memberIds: orderedMembers,
                centerX: sx / n,
                centerY: sy / n
            ))
        }
        return out
    }
}
