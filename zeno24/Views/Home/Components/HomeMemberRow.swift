import SwiftUI

/// Single member entry — SwiftUI port of Flutter iOS UIKit `HomeMemberCell`.
/// Avatar (with battery pill overlapping its bottom edge) on the leading
/// side, name + activity + since lines on the trailing side.
struct HomeMemberRow: View {
    let member: MarkerModel

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            HomeMemberAvatar(
                avatarUrl: member.avatarUrl,
                fallbackInitial: initial,
                batteryPercent: clampedBattery
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(displayName)
                    .font(AppTypography.bodySmBold)
                    .foregroundStyle(AppColors.mainBlack)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(activityText)
                    .font(AppTypography.bodyXsRegular)
                    .foregroundStyle(AppColors.secondaryBlack)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(sinceText)
                    .font(AppTypography.bodyXsRegular)
                    .foregroundStyle(Color(hex: 0x8B98A8))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.top, 0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Derived strings (mirrors UIKit `activityFor` / `sinceFor`)

    private var clampedBattery: Int {
        max(0, min(100, member.batteryPercent))
    }

    private var displayName: String {
        let trimmed = member.displayName.trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty ? "User" : trimmed
    }

    private var initial: String {
        guard let first = displayName.first else { return "?" }
        return String(first).uppercased()
    }

    private var activityText: String {
        switch member.activity {
        case .driving: return "\(Int(member.speedKmh)) Km/s"
        case .running: return AppStrings.Home.activityRunning
        case .walking: return AppStrings.Home.activityWalking
        case .still, .unspecified: return AppStrings.Home.activityAtLocation
        }
    }

    private var sinceText: String {
        guard member.activitySinceMs > 0 else {
            return "\(AppStrings.Home.since) \(AppStrings.Home.justNow)"
        }
        let date = Date(timeIntervalSince1970: TimeInterval(member.activitySinceMs) / 1000)
        let cal = Calendar.current
        let hhmm = Self.timeFormatter.string(from: date)
        if cal.isDateInToday(date) {
            return "\(AppStrings.Home.since) \(AppStrings.Home.today) \(hhmm)"
        }
        if cal.isDateInYesterday(date) {
            return "\(AppStrings.Home.since) \(AppStrings.Home.yesterday) \(hhmm)"
        }
        let day = cal.component(.day, from: date)
        let month = cal.component(.month, from: date)
        return "\(AppStrings.Home.since) \(day).\(month) \(hhmm)"
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
}
