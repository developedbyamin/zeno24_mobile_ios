import UIKit
import MapKit
import CoreLocation

class FlutterMarkerView: UIView {
    private let imageView = UIImageView()
    private var pulseLink: CADisplayLink?
    private var pulseStartTime: CFTimeInterval = 0

    var onTap: (() -> Void)?
    var currentImage: UIImage? { imageView.image }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    func setImageFromFlutter(_ data: Data, size: CGSize? = nil) {
        guard let image = UIImage(data: data) else { return }
        setImage(image, size: size)
    }

    func setImage(_ image: UIImage, size: CGSize? = nil) {
        imageView.image = image
        if let s = size {
            frame.size = s
        } else {
            let scale = UIScreen.main.scale
            frame.size = CGSize(
                width: image.size.width / scale,
                height: image.size.height / scale
            )
        }
    }

    func startPulseAnimation() {
        stopPulseAnimation()
        pulseStartTime = CACurrentMediaTime()
        let link = CADisplayLink(target: self, selector: #selector(pulseTick))
        link.add(to: .main, forMode: .common)
        pulseLink = link
    }

    @objc private func pulseTick() {
        let t = Float(
            (CACurrentMediaTime() - pulseStartTime).truncatingRemainder(dividingBy: 2.0)
        ) / 2.0
        let wave = sin(t * .pi * 2)
        transform = CGAffineTransform(
            scaleX: CGFloat(1.0 + wave * 0.05),
            y: CGFloat(1.0 - wave * 0.03)
        )
    }

    func stopPulseAnimation() {
        pulseLink?.invalidate()
        pulseLink = nil
        transform = .identity
    }

    override func removeFromSuperview() {
        stopPulseAnimation()
        super.removeFromSuperview()
    }
}

final class FlutterPointAnnotation: MKPointAnnotation {
    let markerId: String
    var image: UIImage?
    var imageSize: CGSize = .zero
    var needsFadeIn: Bool = true
    var zPriorityRaw: Float = 0

    init(markerId: String, coordinate: CLLocationCoordinate2D, image: UIImage?, imageSize: CGSize) {
        self.markerId = markerId
        self.image = image
        self.imageSize = imageSize
        super.init()
        self.coordinate = coordinate
    }
}

final class FlutterHeadingAnnotation: MKPointAnnotation {
    var image: UIImage?
    var imageSize: CGSize = .zero
    var headingDegrees: CGFloat = 0

    init(coordinate: CLLocationCoordinate2D, image: UIImage?, imageSize: CGSize) {
        self.image = image
        self.imageSize = imageSize
        super.init()
        self.coordinate = coordinate
    }
}

final class FlutterClusterAnnotation: MKPointAnnotation {
    let clusterId: String
    var memberIds: [String]
    var image: UIImage?
    var imageSize: CGSize = .zero
    var currentScale: CGFloat = 0.7
    var currentAlpha: CGFloat = 0

    init(clusterId: String, memberIds: [String], coordinate: CLLocationCoordinate2D, image: UIImage?, imageSize: CGSize) {
        self.clusterId = clusterId
        self.memberIds = memberIds
        self.image = image
        self.imageSize = imageSize
        super.init()
        self.coordinate = coordinate
    }
}

final class FlutterAnnotationView: MKAnnotationView {
    static let reuseId = "FlutterMarker"

    private let imageView = UIImageView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        startBreathing()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    func bind(_ ann: FlutterPointAnnotation) {
        self.annotation = ann
        let sz = ann.imageSize
        self.bounds = CGRect(x: 0, y: 0, width: sz.width, height: sz.height)
        self.centerOffset = CGPoint(x: 0, y: -sz.height / 2)
        imageView.frame = bounds
        imageView.image = ann.image

        if #available(iOS 14.0, *) {
            self.zPriority = MKAnnotationViewZPriority(rawValue: ann.zPriorityRaw)
        }

        if ann.needsFadeIn {
            ann.needsFadeIn = false
            alpha = 0
            UIView.animate(withDuration: 0.3) { self.alpha = 1 }
        } else {
            alpha = 1
        }
    }

    func updateImage(_ image: UIImage?) {
        imageView.image = image
    }

    private func startBreathing() {
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 1.0 - 0.04
        anim.toValue = 1.0 + 0.04
        anim.duration = 1.2
        anim.autoreverses = true
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(anim, forKey: "breathing")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        alpha = 1
    }
}

final class FlutterHeadingAnnotationView: MKAnnotationView {
    static let reuseId = "FlutterHeading"

    private let imageView = UIImageView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = false
        isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    func bind(_ ann: FlutterHeadingAnnotation) {
        self.annotation = ann
        let sz = ann.imageSize
        self.bounds = CGRect(x: 0, y: 0, width: sz.width, height: sz.height)
        self.centerOffset = .zero
        imageView.frame = bounds
        imageView.image = ann.image
        applyHeading(ann.headingDegrees)
        if #available(iOS 14.0, *) {
            self.zPriority = MKAnnotationViewZPriority(rawValue: 999)
        }
    }

    func applyHeading(_ degrees: CGFloat) {
        transform = CGAffineTransform(rotationAngle: degrees * .pi / 180)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        transform = .identity
    }
}

final class FlutterClusterAnnotationView: MKAnnotationView {
    static let reuseId = "FlutterCluster"

    private let imageView = UIImageView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    func bind(_ ann: FlutterClusterAnnotation) {
        self.annotation = ann
        let sz = ann.imageSize
        self.bounds = CGRect(x: 0, y: 0, width: sz.width, height: sz.height)
        self.centerOffset = .zero
        imageView.frame = bounds
        imageView.image = ann.image
        transform = CGAffineTransform(scaleX: ann.currentScale, y: ann.currentScale)
        alpha = ann.currentAlpha
    }

    func updateImage(_ image: UIImage?) {
        imageView.image = image
    }

    func applyScaleAlpha(scale: CGFloat, alpha: CGFloat) {
        transform = CGAffineTransform(scaleX: scale, y: scale)
        self.alpha = alpha
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        transform = .identity
        alpha = 1
    }
}
