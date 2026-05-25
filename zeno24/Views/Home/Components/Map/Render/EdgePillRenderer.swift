import UIKit

final class EdgePillRenderer {

    private static let white      = UIColor.white
    private static let bgColor    = UIColor(red: 0xF2/255.0, green: 0xF5/255.0, blue: 0xF9/255.0, alpha: 1)
    private static let textColor  = UIColor(red: 0x12/255.0, green: 0x12/255.0, blue: 0x12/255.0, alpha: 1)
    private static let brandColor = UIColor(red: 0x91/255.0, green: 0x71/255.0, blue: 0xF4/255.0, alpha: 1)

    private static let borderW:       CGFloat = 3
    private static let padH:          CGFloat = 8
    private static let padV:          CGFloat = 6
    private static let avatarSize:    CGFloat = 24
    private static let avatarOverlap: CGFloat = 12
    private static let avatarBorder:  CGFloat = 1
    private static let nameSize:      CGFloat = 12
    private static let arrowSize:     CGFloat = 24
    private static let gap:           CGFloat = 2

    struct Result {
        let image: UIImage
        let size: CGSize
    }

    static func renderSingle(
        name: String,
        avatar: UIImage?,
        fallbackColor: UIColor,
        isLeft: Bool
    ) -> Result {
        return render(
            name: name,
            avatars: [avatar],
            fallbackColors: [fallbackColor],
            avatarLabels: [firstLetterOf(name)],
            totalCount: 1,
            isLeft: isLeft
        )
    }

    static func renderCluster(
        primaryName: String,
        avatars: [UIImage?],
        fallbackColors: [UIColor],
        avatarLabels: [String] = [],
        totalCount: Int,
        isLeft: Bool
    ) -> Result {
        return render(
            name: primaryName, avatars: avatars,
            fallbackColors: fallbackColors,
            avatarLabels: avatarLabels,
            totalCount: totalCount, isLeft: isLeft
        )
    }

    private static func firstLetterOf(_ name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        for ch in trimmed where ch.isLetter || ch.isNumber {
            return String(ch).uppercased()
        }
        return ""
    }

    private static func render(
        name: String,
        avatars: [UIImage?],
        fallbackColors: [UIColor],
        avatarLabels: [String],
        totalCount: Int,
        isLeft: Bool
    ) -> Result {

        let maxVisible = 3
        let visibleAvatars = min(avatars.count, totalCount > maxVisible ? maxVisible - 1 : maxVisible)
        let showBadge = totalCount > maxVisible
        let avatarCount = visibleAvatars + (showBadge ? 1 : 0)
        let avatarSectionW: CGFloat = avatarCount <= 0 ? 0 :
            avatarSize + CGFloat(avatarCount - 1) * (avatarSize - avatarOverlap)

        let contentW = avatarSectionW
        let pillW = borderW * 2 + padH * 2 + contentW
        let pillH = borderW * 2 + padV * 2 + avatarSize

        let bmpW = pillW + 2
        let bmpH = pillH + 2

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: bmpW, height: bmpH))
        let image = renderer.image { ctx in
            let g = ctx.cgContext

            let ox: CGFloat = 1
            let oy: CGFloat = 1

            let r = pillH / 2
            let pillRect = CGRect(x: ox, y: oy, width: pillW, height: pillH)
            let borderPath = UIBezierPath(roundedRect: pillRect, cornerRadius: r)
            g.setFillColor(white.cgColor)
            g.addPath(borderPath.cgPath)
            g.fillPath()

            let innerRect = CGRect(
                x: ox + borderW, y: oy + borderW,
                width: pillW - borderW * 2, height: pillH - borderW * 2
            )
            let innerR = innerRect.height / 2
            let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: innerR)
            g.setFillColor(bgColor.cgColor)
            g.addPath(innerPath.cgPath)
            g.fillPath()

            let contentX = ox + borderW + padH
            let centerY = oy + pillH / 2

            var avatarX = contentX
            let avatarCy = centerY
            let avatarR = avatarSize / 2
            let step = avatarSize - avatarOverlap

            for i in 0..<visibleAvatars {
                let cx = avatarX + avatarR
                let fallback = i < fallbackColors.count ? fallbackColors[i] : brandColor
                let label = i < avatarLabels.count ? avatarLabels[i] : ""
                drawCircleAvatar(g, cx: cx, cy: avatarCy, r: avatarR,
                    borderW: avatarBorder,
                    avatar: avatars.count > i ? avatars[i] : nil,
                    fallbackColor: fallback,
                    label: label)
                avatarX += step
            }

            if showBadge {
                let badgeCx = avatarX + avatarR
                drawCountBadge(g, cx: badgeCx, cy: avatarCy, r: avatarR,
                    count: totalCount - visibleAvatars)
            }
        }

        return Result(image: image, size: CGSize(width: bmpW, height: bmpH))
    }

    private static func drawArrowCircle(_ g: CGContext, cx: CGFloat, cy: CGFloat, r: CGFloat, isLeft: Bool) {

        g.setFillColor(textColor.cgColor)
        g.fillEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))

        g.setStrokeColor(white.cgColor)
        g.setLineWidth(2)
        g.setLineCap(.round)
        g.setLineJoin(.round)
        let sz = r * 0.4
        if isLeft {
            g.move(to: CGPoint(x: cx - sz * 0.5, y: cy - sz))
            g.addLine(to: CGPoint(x: cx + sz * 0.5, y: cy))
            g.addLine(to: CGPoint(x: cx - sz * 0.5, y: cy + sz))
        } else {
            g.move(to: CGPoint(x: cx + sz * 0.5, y: cy - sz))
            g.addLine(to: CGPoint(x: cx - sz * 0.5, y: cy))
            g.addLine(to: CGPoint(x: cx + sz * 0.5, y: cy + sz))
        }
        g.strokePath()
    }

    private static func drawCircleAvatar(
        _ g: CGContext, cx: CGFloat, cy: CGFloat, r: CGFloat,
        borderW: CGFloat,
        avatar: UIImage?,
        fallbackColor: UIColor,
        label: String = ""
    ) {

        g.setFillColor(white.cgColor)
        g.fillEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
        let innerR = r - borderW
        g.saveGState()
        let clipPath = UIBezierPath(ovalIn: CGRect(x: cx - innerR, y: cy - innerR, width: innerR * 2, height: innerR * 2))
        g.addPath(clipPath.cgPath)
        g.clip()
        if let avatar = avatar {
            let drawRect = CGRect(x: cx - innerR, y: cy - innerR, width: innerR * 2, height: innerR * 2)
            avatar.draw(in: drawRect)
        } else {
            g.setFillColor(fallbackColor.cgColor)
            g.fillEllipse(in: CGRect(x: cx - innerR, y: cy - innerR, width: innerR * 2, height: innerR * 2))
            if !label.isEmpty {
                let fontSize = innerR * 1.4
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
                    .foregroundColor: UIColor.white,
                ]
                let text = label as NSString
                let size = text.size(withAttributes: attrs)
                let rect = CGRect(
                    x: cx - size.width / 2,
                    y: cy - size.height / 2,
                    width: size.width,
                    height: size.height
                )
                text.draw(in: rect, withAttributes: attrs)
            }
        }
        g.restoreGState()
    }

    private static func drawCountBadge(_ g: CGContext, cx: CGFloat, cy: CGFloat, r: CGFloat, count: Int) {

        g.setFillColor(white.cgColor)
        g.fillEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
        let innerR = r - 1
        g.setFillColor(brandColor.cgColor)
        g.fillEllipse(in: CGRect(x: cx - innerR, y: cy - innerR, width: innerR * 2, height: innerR * 2))
        let text = "\(count)" as NSString
        let font = UIFont.systemFont(ofSize: nameSize, weight: .bold)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: white,
        ]
        let size = text.size(withAttributes: attrs)
        let textRect = CGRect(x: cx - size.width / 2, y: cy - size.height / 2, width: size.width, height: size.height)
        text.draw(in: textRect, withAttributes: attrs)
    }
}
