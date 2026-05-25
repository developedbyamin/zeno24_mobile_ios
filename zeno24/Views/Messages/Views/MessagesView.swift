import SwiftUI

struct MessagesView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    MessageChatRow(
                        title: "Fidan",
                        preview: "Nicat! Are you home? 🏠",
                        time: "17:00 PM",
                        initialBackground: Color(hex: 0xFF5F03)
                    )
                    divider
                    MessageChatRow(
                        title: "Fatima",
                        preview: "I’ll be there in 10 minutes ⏰",
                        time: "12:30 PM",
                        avatarAsset: AppImages.avatarFiruza
                    )
                    MessageChatRow(
                        title: "Fidan battrey is low",
                        preview: "Thanks, Nicat! See you soon ❤️",
                        time: "19:00 PM",
                        avatarAsset: AppImages.avatarNigar
                    )
                    MessageChatRow(
                        title: "Fidan",
                        preview: "Let me know when you arrive 👍",
                        time: "20:00 PM",
                        avatarAsset: AppImages.avatarFidan,
                        unreadCount: 2,
                        highlighted: true
                    )
                    MessageChatRow(
                        title: "Fidan",
                        preview: "Call me when you’re free 📞",
                        time: "12:00 PM",
                        avatarAsset: AppImages.avatarFidanChat
                    )
                    divider
                    MessageChatRow(
                        title: "Fidan",
                        preview: "Almost there — traffic was a bit crazy 😅🚦",
                        time: "11:30 PM",
                        avatarAsset: AppImages.avatarFiruza
                    )
                    divider
                    MessageChatRow(
                        title: "Narmin",
                        preview: "I’m heading out now 🚗✨ Should be there soon.",
                        time: "19:00 PM",
                        avatarAsset: AppImages.avatarNigar
                    )
                    divider
                    MessageChatRow(
                        title: "Fidan",
                        preview: "Where are you right now? 👀",
                        time: "12.01.26  01:50 PM",
                        avatarAsset: AppImages.avatarFidan
                    )

                    Color.clear.frame(height: 80)
                }
                .padding(8)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .background(Color(hex: 0xF6F6F6).ignoresSafeArea())

            CirclePill(fallbackTitle: AppStrings.Messages.circleName)
                .padding(.bottom, 14)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            AppTopBar(title: AppStrings.Messages.title) { dismiss() }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var divider: some View {
        HStack {
            Spacer()
            Color(hex: 0xF2F5F9).frame(height: 1)
        }
        .frame(width: 291, height: 1)
    }
}
