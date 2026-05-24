import SwiftUI
import AVKit

/// Muted, looping, cover-fitted background video for the onboarding screen.
/// Falls back to a solid black surface when the asset is missing.
/// Mirrors `onboard_video_background.dart`.
struct OnboardVideoBackground: View {
    var video: AppVideos.Video = AppVideos.onboard
    var isPlaying: Bool = true

    var body: some View {
        VideoBackgroundLayer(url: video.url, isPlaying: isPlaying)
            .ignoresSafeArea()
    }
}

private struct VideoBackgroundLayer: UIViewRepresentable {
    let url: URL?
    let isPlaying: Bool

    func makeUIView(context: Context) -> PlayerContainerView {
        let view = PlayerContainerView()
        if let url { view.attach(url: url) }
        return view
    }

    func updateUIView(_ uiView: PlayerContainerView, context: Context) {
        uiView.setPlaying(isPlaying)
    }

    // Intentionally NOT tearing the player down — keeps the asset warm so
    // navigating away and back doesn't reload/parse the file every time.
    // The underlying view is short-lived (recreated by SwiftUI) but the
    // player instance is cached on `PlayerContainerView.sharedPlayer`.
}

/// Hosts an `AVPlayerLayer` and keeps it sized to its bounds. Loops via
/// `AVPlayerLooper` — the official Apple API for seamless playback.
///
/// Players are cached by URL on `Self.cache`, so navigating away from the
/// onboarding screen and back does NOT re-parse the asset.
final class PlayerContainerView: UIView {

    // MARK: - Per-URL shared player cache
    private struct Slot {
        let player: AVQueuePlayer
        let looper: AVPlayerLooper
    }
    private static var cache: [URL: Slot] = [:]

    private static func slot(for url: URL) -> Slot {
        if let cached = cache[url] { return cached }
        let item = AVPlayerItem(url: url)
        let queue = AVQueuePlayer(playerItem: item)
        queue.isMuted = true
        queue.actionAtItemEnd = .none
        let looper = AVPlayerLooper(player: queue, templateItem: item)
        let slot = Slot(player: queue, looper: looper)
        cache[url] = slot
        return slot
    }

    // MARK: - Layer
    private let playerLayer = AVPlayerLayer()
    private var player: AVQueuePlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    func attach(url: URL) {
        let slot = Self.slot(for: url)
        self.player = slot.player
        playerLayer.player = slot.player
        slot.player.play()
    }

    func setPlaying(_ playing: Bool) {
        if playing { player?.play() } else { player?.pause() }
    }
}
