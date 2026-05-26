import SwiftUI

/// Chat thread screen (Figma 5865:7143). Uses the chat variant of
/// `AppTopBar` for the two-line header + avatar trailing slot. Body is a
/// scrollable column of date pills and message bubbles; the composer at the
/// bottom is wired via `safeAreaInset` so it pins above the home indicator
/// without floating over the message list.
struct ChatView: View {
    let thread: ChatThread
    @Environment(AppRouter.self) private var router

    @State private var messages: [ChatMessage] = ChatMessage.seed
    @State private var draft: String = ""
    @FocusState private var inputFocused: Bool

    var body: some View {
        messagesScroll
            .background(Color(hex: 0xF6F6F6).ignoresSafeArea())
            .safeAreaInset(edge: .bottom, spacing: 4) {
                ChatComposer(
                    draft: $draft,
                    focused: $inputFocused,
                    onSend: sendDraft,
                    onQuickReply: sendQuickReply
                )
            }
            .chatTopBar(
                title: thread.title,
                subtitle: thread.subtitle,
                avatarAsset: thread.avatarAsset,
                avatarInitialColor: Color(hex: thread.avatarInitialBackground),
                bottomCornerRadius: 16,
                spacing: 4,
                onBack: { router.pop() }
            )
    }

    // MARK: - Messages list

    private var messagesScroll: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(Array(messages.enumerated()), id: \.element.id) { idx, message in
                        rowContent(for: message, index: idx)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onChange(of: messages.count) {
                guard let last = messages.last else { return }
                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
            .onAppear {
                if let last = messages.last {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
        }
    }

    @ViewBuilder
    private func rowContent(for message: ChatMessage, index: Int) -> some View {
        let prevDate = index > 0 ? messages[index - 1].date : nil
        if message.date != prevDate {
            ChatDatePill(date: message.date)
        }
        ChatBubbleRow(message: message, threadAvatar: thread.avatarAsset)
            .transition(.asymmetric(
                insertion: .scale(scale: 0.85, anchor: message.isOutgoing ? .bottomTrailing : .bottomLeading)
                    .combined(with: .opacity),
                removal: .opacity
            ))
    }

    // MARK: - Actions

    private func sendDraft() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        append(text: trimmed)
        draft = ""
    }

    private func sendQuickReply(_ reply: ChatQuickReply) {
        append(text: reply.message)
    }

    private func append(text: String) {
        let message = ChatMessage(
            id: UUID().uuidString,
            text: text,
            time: Self.timeFormatter.string(from: Date()),
            date: messages.last?.date ?? "Today",
            isOutgoing: true,
            isSeen: false
        )
        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
            messages.append(message)
        }
        Haptics.impact(.light)
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()
}
