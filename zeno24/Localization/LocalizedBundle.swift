import Foundation

final class LocalizedBundle: Bundle, @unchecked Sendable {

    // MARK: - Active bundle

    static var currentBundle: Bundle?

    @MainActor
    static func setLanguage(_ code: String) {
        if let path = Bundle.main.path(forResource: code, ofType: "lproj") {
            currentBundle = Bundle(path: path)
        } else {
            currentBundle = nil
        }
    }

    // MARK: - Install

    private static let installOnce: Void = {
        object_setClass(Bundle.main, LocalizedBundle.self)
    }()

    static func install() { _ = installOnce }

    // MARK: - Override

    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        guard let bundle = LocalizedBundle.currentBundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
