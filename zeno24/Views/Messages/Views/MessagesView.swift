import SwiftUI

struct MessagesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router

    private let circleName = AppStrings.Chat.defaultCircle

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(MessageThreads.all.enumerated()), id: \.element.thread.id) { idx, item in
                        Button {
                            router.push(.chat(item.thread))
                        } label: {
                            MessageChatRow(
                                title: item.thread.title,
                                preview: item.preview,
                                time: item.time,
                                avatarAsset: item.thread.avatarAsset,
                                initialBackground: Color(hex: item.thread.avatarInitialBackground),
                                unreadCount: item.unreadCount,
                                highlighted: item.highlighted
                            )
                        }
                        .buttonStyle(MessageRowPressStyle())

                        if item.showDivider, idx < MessageThreads.all.count - 1 {
                            divider
                        }
                    }

                    Color.clear.frame(height: 80)
                }
                .padding(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .ignoresSafeArea(edges: .bottom)

            CirclePill(fallbackTitle: AppStrings.Messages.circleName)
                .padding(.bottom, 14)
        }
        .appTopBar(title: AppStrings.Messages.title, onBack: { dismiss() })
    }

    private var divider: some View {
        HStack {
            Spacer()
            Color(hex: 0xF2F5F9).frame(height: 1)
        }
        .frame(width: 291, height: 1)
    }
}

private struct MessageRowPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Mock thread feed for the Messages list. Each entry carries the
/// `ChatThread` value that will be pushed onto the nav stack when the row is
/// tapped — keeps the screen content + the chat header in lockstep.
private struct MessageThreadItem {
    let thread: ChatThread
    let preview: String
    let time: String
    var unreadCount: Int = 0
    var highlighted: Bool = false
    var showDivider: Bool = true
}

private enum MessageThreads {
    static let all: [MessageThreadItem] = [
        .init(
            thread: ChatThread(
                id: "fidan-1",
                title: "Fidan",
                subtitle: AppStrings.Chat.defaultCircle,
                avatarAsset: nil,
                avatarInitialBackground: 0xFF5F03
            ),
            preview: "Nicat! Are you home? 🏠",
            time: "17:00 PM"
        ),
        .init(
            thread: ChatThread(
                id: "fatima-1",
                title: "Fatima",
                subtitle: AppStrings.Chat.defaultCircle,
                avatarAsset: AppImages.avatarFiruza
            ),
            preview: "I’ll be there in 10 minutes ⏰",
            time: "12:30 PM",
            showDivider: false
        ),
        .init(
            thread: ChatThread(
                id: "nigar-1",
                title: "Fidan battrey is low",
                subtitle: AppStrings.Chat.defaultCircle,
                avatarAsset: AppImages.avatarNigar
            ),
            preview: "Thanks, Nicat! See you soon ❤️",
            time: "19:00 PM",
            showDivider: false
        ),
        .init(
            thread: ChatThread(
                id: "fidan-2",
                title: "Fidan",
                subtitle: AppStrings.Chat.defaultCircle,
                avatarAsset: AppImages.avatarFidan
            ),
            preview: "Let me know when you arrive 👍",
            time: "20:00 PM",
            unreadCount: 2,
            highlighted: true,
            showDivider: false
        ),
        .init(
            thread: ChatThread(
                id: "fidan-3",
                title: "Fidan",
                subtitle: AppStrings.Chat.defaultCircle,
                avatarAsset: AppImages.avatarFidanChat
            ),
            preview: "Call me when you’re free 📞",
            time: "12:00 PM"
        ),
        .init(
            thread: ChatThread(
                id: "fatima-2",
                title: "Fidan",
                subtitle: AppStrings.Chat.defaultCircle,
                avatarAsset: AppImages.avatarFiruza
            ),
            preview: "Almost there — traffic was a bit crazy 😅🚦",
            time: "11:30 PM"
        ),
        .init(
            thread: ChatThread(
                id: "narmin-1",
                title: "Narmin",
                subtitle: AppStrings.Chat.defaultCircle,
                avatarAsset: AppImages.avatarNigar
            ),
            preview: "I’m heading out now 🚗✨ Should be there soon.",
            time: "19:00 PM"
        ),
        .init(
            thread: ChatThread(
                id: "fidan-4",
                title: "Fidan",
                subtitle: AppStrings.Chat.defaultCircle,
                avatarAsset: AppImages.avatarFidan
            ),
            preview: "Where are you right now? 👀",
            time: "12.01.26  01:50 PM",
            showDivider: false
        ),
    ]
}
