import UIKit

enum ClusterRenderer {

    private static let WHITE = UIColor.white

    private static let HALO_FILL = UIColor(red: 0xB8/255.0, green: 0xA9/255.0, blue: 0xD9/255.0, alpha: 0.40)
    private static let HALO_STROKE = UIColor(red: 0xB8/255.0, green: 0xA9/255.0, blue: 0xD9/255.0, alpha: 0.50)
    private static let BRAND = UIColor(red: 0x91/255.0, green: 0x71/255.0, blue: 0xF4/255.0, alpha: 1)

    static func render(
        memberCount: Int,
        memberAvatars: [UIImage?],
        memberInitials: [String],
        memberFallbackColors: [UIColor]
    ) -> UIImage {
        let w = MarkerRenderer.pinWidth
        let h = MarkerRenderer.pinHeight
        let size = CGSize(width: w, height: h)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { ctx in
            let cg = ctx.cgContext
            let cx = w / 2
            let cy = h / 2

            let haloR = (min(w, h) / 2) - 2
            drawHalo(in: cg, cx: cx, cy: cy, r: haloR)

            let visible = min(memberCount, 3)
            let avatarR = haloR * 0.42
            let borderW: CGFloat = 3.5
            let spacing = avatarR * 1.45

            switch visible {
            case 2:
                let leftCx = cx - spacing / 2
                let rightCx = cx + spacing / 2
                drawAvatarWithBorder(in: cg, cx: leftCx, cy: cy, r: avatarR, borderW: borderW,
                    avatar: memberAvatars.indices.contains(0) ? memberAvatars[0] : nil,
                    initial: memberInitials.indices.contains(0) ? memberInitials[0] : "?",
                    fallback: memberFallbackColors.indices.contains(0) ? memberFallbackColors[0] : HALO_FILL)
                drawAvatarWithBorder(in: cg, cx: rightCx, cy: cy, r: avatarR, borderW: borderW,
                    avatar: memberAvatars.indices.contains(1) ? memberAvatars[1] : nil,
                    initial: memberInitials.indices.contains(1) ? memberInitials[1] : "?",
                    fallback: memberFallbackColors.indices.contains(1) ? memberFallbackColors[1] : HALO_FILL)
            default:
                let rowGap = spacing * 0.78
                let colOffset = spacing / 2
                let topY = cy - rowGap / 2
                let botY = cy + rowGap / 2

                drawAvatarWithBorder(in: cg, cx: cx - colOffset, cy: topY, r: avatarR, borderW: borderW,
                    avatar: memberAvatars.indices.contains(0) ? memberAvatars[0] : nil,
                    initial: memberInitials.indices.contains(0) ? memberInitials[0] : "?",
                    fallback: memberFallbackColors.indices.contains(0) ? memberFallbackColors[0] : HALO_FILL)
                drawAvatarWithBorder(in: cg, cx: cx + colOffset, cy: topY, r: avatarR, borderW: borderW,
                    avatar: memberAvatars.indices.contains(1) ? memberAvatars[1] : nil,
                    initial: memberInitials.indices.contains(1) ? memberInitials[1] : "?",
                    fallback: memberFallbackColors.indices.contains(1) ? memberFallbackColors[1] : HALO_FILL)
                drawAvatarWithBorder(in: cg, cx: cx, cy: botY, r: avatarR, borderW: borderW,
                    avatar: memberAvatars.indices.contains(2) ? memberAvatars[2] : nil,
                    initial: memberInitials.indices.contains(2) ? memberInitials[2] : "?",
                    fallback: memberFallbackColors.indices.contains(2) ? memberFallbackColors[2] : HALO_FILL)
            }

            if memberCount > 3 {
                let badgeR: CGFloat = 12
                let badgeCx = cx + haloR * 0.62
                let badgeCy = cy + haloR * 0.62
                drawCountBadge(in: cg, cx: badgeCx, cy: badgeCy, r: badgeR, extra: memberCount - 3)
            }
        }
    }

    private static func drawHalo(in cg: CGContext, cx: CGFloat, cy: CGFloat, r: CGFloat) {

        HALO_FILL.setFill()
        UIBezierPath(ovalIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)).fill()

        let ringStrokeW: CGFloat = 1.5
        HALO_STROKE.setStroke()
        let ring = UIBezierPath(ovalIn: CGRect(
            x: cx - r + ringStrokeW / 2,
            y: cy - r + ringStrokeW / 2,
            width: (r - ringStrokeW / 2) * 2,
            height: (r - ringStrokeW / 2) * 2
        ))
        ring.lineWidth = ringStrokeW
        ring.stroke()
    }

    private static func drawAvatarWithBorder(
        in cg: CGContext,
        cx: CGFloat, cy: CGFloat, r: CGFloat,
        borderW: CGFloat,
        avatar: UIImage?,
        initial: String,
        fallback: UIColor
    ) {

        WHITE.setFill()
        UIBezierPath(ovalIn: CGRect(
            x: cx - r - borderW, y: cy - r - borderW,
            width: (r + borderW) * 2, height: (r + borderW) * 2
        )).fill()

        let avatarRect = CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)

        cg.saveGState()
        UIBezierPath(ovalIn: avatarRect).addClip()

        if let avatar = avatar {
            let imgW = avatar.size.width
            let imgH = avatar.size.height
            if imgW > 0, imgH > 0 {
                let scale = max(avatarRect.width / imgW, avatarRect.height / imgH)
                let drawW = imgW * scale
                let drawH = imgH * scale
                let drawRect = CGRect(
                    x: avatarRect.midX - drawW / 2,
                    y: avatarRect.midY - drawH / 2,
                    width: drawW, height: drawH
                )
                avatar.draw(in: drawRect)
            } else {
                avatar.draw(in: avatarRect)
            }
        } else {
            fallback.setFill()
            UIRectFill(avatarRect)
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: r * 0.95, weight: .bold),
                .foregroundColor: UIColor.white,
            ]
            let txt = (initial.isEmpty ? "?" : initial) as NSString
            let sz = txt.size(withAttributes: attrs)
            let pt = CGPoint(x: cx - sz.width / 2, y: cy - sz.height / 2)
            txt.draw(at: pt, withAttributes: attrs)
        }
        cg.restoreGState()
    }

    private static func drawCountBadge(
        in cg: CGContext,
        cx: CGFloat, cy: CGFloat, r: CGFloat,
        extra: Int
    ) {
        let borderW: CGFloat = 2
        WHITE.setFill()
        UIBezierPath(ovalIn: CGRect(
            x: cx - r - borderW, y: cy - r - borderW,
            width: (r + borderW) * 2, height: (r + borderW) * 2
        )).fill()

        BRAND.setFill()
        UIBezierPath(ovalIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)).fill()

        let text = "+\(extra)" as NSString
        let fontSize = extra >= 100 ? r * 0.7 : r * 0.85
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
            .foregroundColor: UIColor.white,
        ]
        let sz = text.size(withAttributes: attrs)
        let pt = CGPoint(x: cx - sz.width / 2, y: cy - sz.height / 2)
        text.draw(at: pt, withAttributes: attrs)
    }
}
