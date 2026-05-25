import SwiftUI

struct KidsBoardPill: View {
    var body: some View {
        HStack(spacing: 4) {
            HStack(spacing: 8) {
                Image(AppImages.avatarFidan)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                Text(AppStrings.Kids.board)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.16), in: Capsule())

            Button {
                // TODO: switch board
            } label: {
                Image(systemName: "chevron.up")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.white.opacity(0.24), in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color(hex: 0x121212), in: Capsule())
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 16, x: 0, y: 16)
    }
}
