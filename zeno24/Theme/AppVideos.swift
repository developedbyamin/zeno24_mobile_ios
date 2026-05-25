import Foundation

enum AppVideos {
    static let onboard = Video(name: "onboard", ext: "mp4")

    struct Video {
        let name: String
        let ext: String

        var url: URL? { Bundle.main.url(forResource: name, withExtension: ext) }
    }
}
