import UIKit

final class MarkerRenderer {

    private static let mainBlack  = UIColor(red: 0x12/255.0, green: 0x12/255.0, blue: 0x12/255.0, alpha: 1)
    private static let mainGray   = UIColor(red: 0xF2/255.0, green: 0xF5/255.0, blue: 0xF9/255.0, alpha: 1)
    private static let green      = UIColor(red: 0x3D/255.0, green: 0xC5/255.0, blue: 0x62/255.0, alpha: 1)
    private static let brandColor = UIColor(red: 0x91/255.0, green: 0x71/255.0, blue: 0xF4/255.0, alpha: 1)

    static let pinWidth:  CGFloat = 80
    static let pinHeight: CGFloat = 80

    static let selfWidth:  CGFloat = 80
    static let selfHeight: CGFloat = 80

    static let headingWidth:  CGFloat = 80
    static let headingHeight: CGFloat = 160

    private static func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        .systemFont(ofSize: size, weight: weight)
    }

    static func emoji(for activity: String) -> String {
        switch activity {
        case "driving": return "🚗"
        case "running": return "🏃"
        case "walking": return "🚶"
        default:        return "📍"
        }
    }

    private static func statusTexts(
        activity: String,
        speedKmh: Double,
        activitySinceMs: Int
    ) -> (lead: String, value: String) {
        let duration = durationLabel(activitySinceMs)
        switch activity {
        case "driving": return ("\(Int(speedKmh.rounded())) Km/s", duration)
        case "running": return ("running", duration)
        default:        return ("here for", duration)
        }
    }

    private static func durationLabel(_ sinceMs: Int) -> String {
        guard sinceMs > 0 else { return "now" }
        let diff = Int(Date().timeIntervalSince1970 * 1000) - sinceMs
        guard diff >= 60_000 else { return "now" }
        let minutes = diff / 60_000
        if minutes < 60 { return "\(minutes) min" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h" }
        return "\(hours / 24)d"
    }

    static func renderPin(
        avatar: UIImage?,
        displayName: String,
        activity: String,
        speedKmh: Double,
        activitySinceMs: Int,
        fallbackColor: UIColor
    ) -> UIImage {
        let size = CGSize(width: pinWidth, height: pinHeight)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { ctx in
            let cg = ctx.cgContext

            let pinW: CGFloat = 60
            let pinH: CGFloat = 65
            let pinX = (size.width - pinW) / 2
            let pinY = size.height - pinH

            drawTeardrop(in: cg, x: pinX, y: pinY, w: pinW, h: pinH)

            let avatarD: CGFloat = 54
            let avatarX = pinX + 3
            let avatarY = pinY + 3
            let avatarRect = CGRect(x: avatarX, y: avatarY, width: avatarD, height: avatarD)

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
                        width: drawW,
                        height: drawH
                    )
                    avatar.draw(in: drawRect)
                } else {
                    avatar.draw(in: avatarRect)
                }
            } else {
                fallbackColor.setFill()
                UIRectFill(avatarRect)
                let initial = initialLetter(displayName)
                let initAttrs: [NSAttributedString.Key: Any] = [
                    .font: font(size: 20, weight: .bold),
                    .foregroundColor: UIColor.white,
                ]
                let initSize = (initial as NSString).size(withAttributes: initAttrs)
                let initPt = CGPoint(
                    x: avatarRect.midX - initSize.width / 2,
                    y: avatarRect.midY - initSize.height / 2
                )
                (initial as NSString).draw(at: initPt, withAttributes: initAttrs)
            }
            cg.restoreGState()

            let badgeD: CGFloat = 24
            let badgeBorder: CGFloat = 2
            let badgeX = pinX + pinW - badgeD
            let badgeY = pinY + 38
            let badgeRect = CGRect(x: badgeX, y: badgeY, width: badgeD, height: badgeD)
            let badgePath = UIBezierPath(ovalIn: badgeRect)

            mainGray.setFill()
            badgePath.fill()
            UIColor.white.setStroke()
            badgePath.lineWidth = badgeBorder
            badgePath.stroke()

            let emojiStr = emoji(for: activity)
            let emojiAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
            ]
            let emojiSize = (emojiStr as NSString).size(withAttributes: emojiAttrs)
            let emojiPt = CGPoint(
                x: badgeRect.midX - emojiSize.width / 2,
                y: badgeRect.midY - emojiSize.height / 2
            )
            (emojiStr as NSString).draw(at: emojiPt, withAttributes: emojiAttrs)
        }
    }

    static func renderSelf(avatar: UIImage) -> UIImage {
        return renderPin(
            avatar: avatar,
            displayName: "You",
            activity: "still",
            speedKmh: 0,
            activitySinceMs: 0,
            fallbackColor: brandColor
        )
    }

    static func renderHeadingIndicator() -> UIImage {
        let size = CGSize(width: headingWidth, height: headingHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            let cx = size.width / 2
            let cy = size.height / 2

            drawHeadingCone(in: cg, apexX: cx, apexY: cy)
            drawGlowIndicator(in: cg, centerX: cx, centerY: cy, d: 20)
        }
    }

    private static func drawHeadingCone(in cg: CGContext, apexX: CGFloat, apexY: CGFloat) {

        let svgApexX: CGFloat = 30.5455
        let svgApexY: CGFloat = 1.30
        func p(_ sx: CGFloat, _ sy: CGFloat) -> CGPoint {
            return CGPoint(
                x: apexX + (sx - svgApexX),
                y: apexY - (sy - svgApexY)
            )
        }

        let path = UIBezierPath()
        path.move(to: p(28.67, 1.30))
        path.addCurve(
            to: p(32.42, 1.30),
            controlPoint1: p(29.32, -0.43),
            controlPoint2: p(31.77, -0.43)
        )
        path.addLine(to: p(60.96, 77.59))
        path.addCurve(
            to: p(59.08, 80.29),
            controlPoint1: p(61.45, 78.90),
            controlPoint2: p(60.48, 80.29)
        )
        path.addLine(to: p(2.00, 80.29))
        path.addCurve(
            to: p(0.13, 77.59),
            controlPoint1: p(0.61, 80.29),
            controlPoint2: p(-0.36, 78.90)
        )
        path.close()

        guard let space = CGColorSpace(name: CGColorSpace.sRGB) else { return }

        let colors: [CGColor] = [
            UIColor(red: 0xC0/255.0, green: 0x75/255.0, blue: 0xF4/255.0, alpha: 1.00).cgColor,
            UIColor(red: 0x92/255.0, green: 0x51/255.0, blue: 0xB9/255.0, alpha: 0.02).cgColor,
        ]
        guard let gradient = CGGradient(colorsSpace: space, colors: colors as CFArray, locations: [0.0, 1.0]) else { return }

        cg.saveGState()
        path.addClip()

        let gStart = p(svgApexX, -3.708)
        let gEnd   = p(svgApexX, 79.1469)
        cg.drawLinearGradient(
            gradient,
            start: gStart,
            end: gEnd,
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        )
        cg.restoreGState()
    }

    private static func drawGlowIndicator(in cg: CGContext, centerX cx: CGFloat, centerY cy: CGFloat, d: CGFloat) {
        let outerR = d / 2

        guard let space = CGColorSpace(name: CGColorSpace.sRGB) else { return }

        let haloColors: [CGColor] = [
            UIColor(red: 0xD6/255.0, green: 0x5D/255.0, blue: 0x7C/255.0, alpha: 0.3).cgColor,
            UIColor(red: 0xD6/255.0, green: 0x5D/255.0, blue: 0x7C/255.0, alpha: 0.3).cgColor,
            UIColor(red: 0x91/255.0, green: 0x71/255.0, blue: 0xF4/255.0, alpha: 0.0).cgColor,
        ]
        let haloLocs: [CGFloat] = [0.0, 0.846, 1.0]
        if let halo = CGGradient(colorsSpace: space, colors: haloColors as CFArray, locations: haloLocs) {
            cg.saveGState()
            UIBezierPath(ovalIn: CGRect(x: cx - outerR, y: cy - outerR, width: d, height: d)).addClip()
            cg.drawRadialGradient(
                halo,
                startCenter: CGPoint(x: cx, y: cy),
                startRadius: 0,
                endCenter: CGPoint(x: cx, y: cy),
                endRadius: outerR,
                options: []
            )
            cg.restoreGState()
        }

        let coreD = d * 0.3
        let coreR = coreD / 2
        let coreRect = CGRect(x: cx - coreR, y: cy - coreR, width: coreD, height: coreD)

        let coreColors: [CGColor] = [
            UIColor(red: 0xEB/255.0, green: 0x66/255.0, blue: 0x59/255.0, alpha: 1).cgColor,
            UIColor(red: 0xEB/255.0, green: 0x66/255.0, blue: 0x59/255.0, alpha: 1).cgColor,
            UIColor(red: 0xAC/255.0, green: 0x4C/255.0, blue: 0xC0/255.0, alpha: 1).cgColor,
            UIColor(red: 0x91/255.0, green: 0x71/255.0, blue: 0xF4/255.0, alpha: 1).cgColor,
        ]
        let coreLocs: [CGFloat] = [0.0, 0.244, 0.722, 1.0]
        if let core = CGGradient(colorsSpace: space, colors: coreColors as CFArray, locations: coreLocs) {
            cg.saveGState()
            UIBezierPath(ovalIn: coreRect).addClip()
            cg.drawLinearGradient(
                core,
                start: CGPoint(x: coreRect.minX, y: cy),
                end:   CGPoint(x: coreRect.maxX, y: cy),
                options: []
            )
            cg.restoreGState()
        }
    }

    private static func drawTeardrop(in cg: CGContext, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        let r = w / 2
        let cx = x + r
        let tailHalf: CGFloat = 6

        let joinDy = sqrt(r * r - tailHalf * tailHalf)
        let leftJoin  = CGPoint(x: cx - tailHalf, y: y + r + joinDy)
        let rightJoin = CGPoint(x: cx + tailHalf, y: y + r + joinDy)

        let path = UIBezierPath()

        path.move(to: rightJoin)
        path.addArc(
            withCenter: CGPoint(x: cx, y: y + r),
            radius: r,
            startAngle: atan2(rightJoin.y - (y + r), rightJoin.x - cx),
            endAngle: atan2(leftJoin.y - (y + r), leftJoin.x - cx),
            clockwise: false
        )

        path.addCurve(
            to: rightJoin,
            controlPoint1: CGPoint(x: cx - 4, y: y + h - 1),
            controlPoint2: CGPoint(x: cx + 4, y: y + h - 1)
        )
        path.close()

        cg.saveGState()
        cg.setShadow(offset: .zero, blur: 12, color: UIColor(white: 0, alpha: 0.2).cgColor)
        UIColor.white.setFill()
        path.fill()
        cg.restoreGState()

        UIColor.white.setFill()
        path.fill()
    }

    private static func initialLetter(_ name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard let first = trimmed.first else { return "?" }
        return String(first).uppercased()
    }

    static func color(fromARGB hex: Int) -> UIColor {
        let a = CGFloat((hex >> 24) & 0xFF) / 255
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >>  8) & 0xFF) / 255
        let b = CGFloat( hex        & 0xFF) / 255
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    private static var imageCache = NSCache<NSString, UIImage>()

    static func loadImage(
        url: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        if let cached = imageCache.object(forKey: url as NSString) {
            completion(cached)
            return
        }

        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            var image: UIImage?
            if let data = data {
                image = UIImage(data: data)
                if let img = image {
                    imageCache.setObject(img, forKey: url as NSString)
                }
            }
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}
