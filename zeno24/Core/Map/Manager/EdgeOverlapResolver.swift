import UIKit

final class EdgeOverlapResolver {

    struct EdgeSlot {
        var id: String
        var y: CGFloat
    }

    private var leftBuf: [EdgeSlot] = []
    private var rightBuf: [EdgeSlot] = []

    func beginPass() {
        leftBuf.removeAll(keepingCapacity: true)
        rightBuf.removeAll(keepingCapacity: true)
    }

    func pushLeft(id: String, y: CGFloat) {
        leftBuf.append(EdgeSlot(id: id, y: y))
    }

    func pushRight(id: String, y: CGFloat) {
        rightBuf.append(EdgeSlot(id: id, y: y))
    }

    func resolve(safeTop: CGFloat, safeBottom: CGFloat, widthOf: (String) -> CGFloat) {
        resolveSide(buf: &leftBuf, safeTop: safeTop, safeBottom: safeBottom, widthOf: widthOf)
        resolveSide(buf: &rightBuf, safeTop: safeTop, safeBottom: safeBottom, widthOf: widthOf)
    }

    func forEachLeft(_ action: (String, CGFloat) -> Void) {
        for slot in leftBuf { action(slot.id, slot.y) }
    }

    func forEachRight(_ action: (String, CGFloat) -> Void) {
        for slot in rightBuf { action(slot.id, slot.y) }
    }

    private func resolveSide(
        buf: inout [EdgeSlot],
        safeTop: CGFloat,
        safeBottom: CGFloat,
        widthOf: (String) -> CGFloat
    ) {
        let n = buf.count
        guard n > 0 else { return }

        for i in 0..<n {
            let h = widthOf(buf[i].id) / 2
            buf[i].y = max(safeTop + h, min(safeBottom - h, buf[i].y))
        }
        guard n > 1 else { return }

        for i in 1..<n {
            let x = buf[i]
            var j = i - 1
            while j >= 0 && buf[j].y > x.y {
                buf[j + 1] = buf[j]
                j -= 1
            }
            buf[j + 1] = x
        }

        for i in 1..<n {
            let ph = widthOf(buf[i - 1].id) / 2
            let ch = widthOf(buf[i].id) / 2
            let minY = buf[i - 1].y + ph + ch + 1
            if buf[i].y < minY {
                buf[i].y = min(minY, safeBottom - ch)
            }
        }

        if n >= 2 {
            for i in stride(from: n - 2, through: 0, by: -1) {
                let nh = widthOf(buf[i + 1].id) / 2
                let ch = widthOf(buf[i].id) / 2
                let maxY = buf[i + 1].y - nh - ch - 1
                if buf[i].y > maxY {
                    buf[i].y = max(maxY, safeTop + ch)
                }
            }
        }
    }
}
