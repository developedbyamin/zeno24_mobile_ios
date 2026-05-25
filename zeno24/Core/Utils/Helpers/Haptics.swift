import UIKit

enum Haptics {
    enum ImpactStyle {
        case light, medium, heavy, soft, rigid

        fileprivate var uiKit: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .light:  return .light
            case .medium: return .medium
            case .heavy:  return .heavy
            case .soft:   return .soft
            case .rigid:  return .rigid
            }
        }
    }

    enum Notification {
        case success, warning, error

        fileprivate var uiKit: UINotificationFeedbackGenerator.FeedbackType {
            switch self {
            case .success: return .success
            case .warning: return .warning
            case .error:   return .error
            }
        }
    }

    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    static func impact(_ style: ImpactStyle = .medium) {
        UIImpactFeedbackGenerator(style: style.uiKit).impactOccurred()
    }

    static func notify(_ type: Notification) {
        UINotificationFeedbackGenerator().notificationOccurred(type.uiKit)
    }
}
