import SwiftUI

struct HomeMemberAvatar: View {
    let avatarUrl: String
    let fallbackInitial: String
    let batteryPercent: Int

    private let avatarSize: CGFloat = 56
    private let pillHeight: CGFloat = 20

    var body: some View {
        ZStack(alignment: .top) {
            avatarCircle
            batteryPill
                .offset(y: avatarSize - pillHeight / 2)
        }
        .frame(width: avatarSize, height: avatarSize + pillHeight / 2)
    }

    // MARK: - Avatar

    @ViewBuilder
    private var avatarCircle: some View {
        ZStack {
            Circle().fill(Color(hex: 0xFF5F03))

            if let url = URL(string: avatarUrl), !avatarUrl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        Text(fallbackInitial)
                            .font(AppTypography.headingXsBold)
                            .foregroundStyle(.white)
                    }
                }
            } else {
                Text(fallbackInitial)
                    .font(AppTypography.headingXsBold)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: avatarSize, height: avatarSize)
        .clipShape(Circle())
    }

    // MARK: - Battery pill

    private var batteryPill: some View {
        HStack(spacing: 3) {
            Image(isLow ? AppVectors.lowBattery : AppVectors.fullBattery)
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
            Text("\(batteryPercent)%")
                .font(AppTypography.body2XsBold)
                .foregroundStyle(batteryColor)
        }
        .padding(.horizontal, 6)
        .frame(height: pillHeight)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(
            Capsule().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 2)
        )
    }

    private var isLow: Bool { batteryPercent <= 20 }

    private var batteryColor: Color {
        isLow ? Color(hex: 0xF70505) : Color(hex: 0x3DC562)
    }
}
