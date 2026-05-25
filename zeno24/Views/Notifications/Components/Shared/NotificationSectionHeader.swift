import SwiftUI

struct NotificationSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppTypography.bodyXsBold)
            .foregroundStyle(Color(hex: 0x292D32))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color(hex: 0xF8F7FF))
    }
}
