import SwiftUI

enum CircleFlowMetrics {
    static let contentHorizontalPadding: CGFloat = 10
    static let contentTopPadding: CGFloat = 12
    static let contentBottomPadding: CGFloat = 16

    static let headerHeight: CGFloat = 48
    static let headerBackButtonSize: CGFloat = 32
    static let headerBackIconSize: CGFloat = 16

    static let primaryButtonHeight: CGFloat = 52

    static let rowHeight: CGFloat = 64
    static let rowDividerHeight: CGFloat = 1
    static let maxVisibleRows: Int = 7
    static let avatarSize: CGFloat = 48

    static let codeLength: Int = 6
    static let codeShakeAmplitude: CGFloat = 8

    static let stepCrossFadeDuration: Double = 0.22
    static let overlayFadeDuration: Double = 0.22
    static let overlayDismissDuration: Double = 0.20
    static let focusDelay: Duration = .milliseconds(250)
}
