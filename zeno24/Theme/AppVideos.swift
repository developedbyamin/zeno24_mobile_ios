import Foundation

/// Typed accessors for bundled video assets — mirrors lib/core/config/constants/app_videos.dart
/// File layout: `Resources/Videos/<name>.<ext>`.
enum AppVideos {
    /// Onboarding background video (3-shot loop).
    static let onboard = Video(name: "onboard", ext: "mp4")

    struct Video {
        let name: String
        let ext: String

        /// Bundle URL — `nil` if the file is missing from the app bundle.
        var url: URL? { Bundle.main.url(forResource: name, withExtension: ext) }
    }
}
