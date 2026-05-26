import SwiftUI

/// Centered date capsule that separates message groups in the chat scroll
/// (Figma 5865:7227).
struct ChatDatePill: View {
    let date: String

    var body: some View {
        Text(date)
            .font(AppTypography.bodyXsSemiBold)
            .foregroundStyle(Color(hex: 0x292D32))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(hex: 0xF2F5F9), in: Capsule())
            .frame(maxWidth: .infinity)
    }
}
