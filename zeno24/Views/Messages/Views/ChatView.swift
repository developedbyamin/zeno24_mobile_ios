import SwiftUI

/// Chat thread screen (Figma 5865:7143). Uses the chat variant of
/// `AppTopBar` for the two-line header + avatar trailing slot. Body is a
/// scrollable column of date pills and message bubbles; the composer at the
/// bottom is a horizontally-scrolling row of quick-reply chips above a
/// rounded text input with a send button.
struct ChatView: View {
    let thread: ChatThread
    @Environment(AppRouter.self) private var router

    @State private var messages: [ChatMessage] = ChatMessage.seed
    @State private var draft: String = ""
    @State private var inputFocused: Bool = false
    @FocusState private var focusedField: Bool

    var body: some View {
        VStack(spacing: 4) {
            messagesScroll
            composer
        }
        .background(Color(hex: 0xF6F6F6).ignoresSafeArea())
        .chatTopBar(
            title: thread.title,
            subtitle: thread.subtitle,
            avatarAsset: thread.avatarAsset,
            avatarInitialColor: Color(hex: thread.avatarInitialBackground),
            bottomCornerRadius: 16,
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
            datePill(message.date)
        }
        ChatBubbleRow(message: message, threadAvatar: thread.avatarAsset)
            .transition(.asymmetric(
                insertion: .scale(scale: 0.85, anchor: message.isOutgoing ? .bottomTrailing : .bottomLeading)
                    .combined(with: .opacity),
                removal: .opacity
            ))
    }

    private func datePill(_ date: String) -> some View {
        Text(date)
            .font(AppTypography.bodyXsSemiBold)
            .foregroundStyle(Color(hex: 0x292D32))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(hex: 0xF2F5F9), in: Capsule())
            .frame(maxWidth: .infinity)
    }

    // MARK: - Composer

    private var composer: some View {
        VStack(spacing: 12) {
            quickReplies
            inputRow
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 32)
        .background(
            Color.white,
            in: UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: 16, topTrailing: 16),
                style: .continuous
            )
        )
        .ignoresSafeArea(edges: .bottom)
    }

    private var quickReplies: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(QuickReply.allCases) { reply in
                    quickReplyChip(reply)
                }
            }
        }
        // Allows the chips to bleed slightly past the rounded composer edge
        // without clipping the press feedback.
        .padding(.horizontal, -16)
        .padding(.horizontal, 16)
    }

    private func quickReplyChip(_ reply: QuickReply) -> some View {
        Button {
            sendQuickReply(reply)
        } label: {
            HStack(spacing: 6) {
                Image(reply.iconAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(reply.title)
                    .font(AppTypography.bodyXsBold)
                    .foregroundStyle(AppColors.mainBlack)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(height: 32)
            .background(Color(hex: 0xF2F5F9), in: Capsule())
        }
        .buttonStyle(ChatPressStyle())
    }

    private var inputRow: some View {
        HStack(spacing: 8) {
            TextField(
                "",
                text: $draft,
                prompt: Text(AppStrings.Chat.placeholder)
                    .foregroundStyle(Color(hex: 0x8B98A8))
            )
            .font(AppTypography.bodySmSemiBold)
            .foregroundStyle(AppColors.mainBlack)
            .submitLabel(.send)
            .focused($focusedField)
            .onSubmit(sendDraft)

            sendButton
        }
        .padding(.leading, 16)
        .padding(.trailing, 4)
        .frame(height: 48)
        .background(Color.white, in: Capsule())
        .overlay(Capsule().strokeBorder(Color(hex: 0xF2F5F9), lineWidth: 1))
    }

    @ViewBuilder
    private var sendButton: some View {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        let isActive = !trimmed.isEmpty
        Button(action: sendDraft) {
            Image(systemName: "arrow.up")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(
                    Circle().fill(isActive ? AppColors.brand : Color(hex: 0xC9C9D6))
                )
        }
        .buttonStyle(ChatPressStyle())
        .disabled(!isActive)
        .animation(.easeInOut(duration: 0.18), value: isActive)
    }

    // MARK: - Actions

    private func sendDraft() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        append(text: trimmed)
        draft = ""
    }

    private func sendQuickReply(_ reply: QuickReply) {
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

// MARK: - Press style

private struct ChatPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Quick reply chip data

private enum QuickReply: String, CaseIterable, Identifiable {
    case love, hello, write, call

    var id: String { rawValue }

    var title: String {
        switch self {
        case .love:  AppStrings.Chat.quickLoveYou
        case .hello: AppStrings.Chat.quickSayHello
        case .write: AppStrings.Chat.quickWriteMe
        case .call:  AppStrings.Chat.quickCallMe
        }
    }

    var iconAsset: String {
        switch self {
        case .love:  AppImages.emojiHeartRed
        case .hello: AppImages.emojiWave
        case .write: AppImages.emojiChatBubble
        case .call:  AppImages.emojiPhone
        }
    }

    var message: String {
        switch self {
        case .love:  "Love you ❤️"
        case .hello: "Hello! 👋"
        case .write: "Write me when you can 💬"
        case .call:  "Call me 📞"
        }
    }
}

// MARK: - Message model + seed

struct ChatMessage: Identifiable, Hashable {
    let id: String
    let text: String
    let time: String
    let date: String
    let isOutgoing: Bool
    var isSeen: Bool

    static let seed: [ChatMessage] = [
        ChatMessage(
            id: "1",
            text: "Hey sweetie, I see you just left school. Do you want me to pick you up or are you walking with Emma today? 🥰",
            time: "12:25 PM",
            date: "Dec 03",
            isOutgoing: false,
            isSeen: true
        ),
        ChatMessage(
            id: "2",
            text: "Do you want me to pick you up or are you walking with Emma today? 🥰",
            time: "12:30 PM",
            date: "Dec 03",
            isOutgoing: true,
            isSeen: true
        ),
    ]
}

// MARK: - Bubble row

private struct ChatBubbleRow: View {
    let message: ChatMessage
    let threadAvatar: String?

    private static let incomingAvatar = AppImages.avatarChatOther
    private static let outgoingAvatar = AppImages.avatarChatMe

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            if message.isOutgoing {
                Spacer(minLength: 0)
                bubble
                avatar(asset: Self.outgoingAvatar)
            } else {
                avatar(asset: threadAvatar ?? Self.incomingAvatar)
                bubble
                Spacer(minLength: 0)
            }
        }
    }

    private func avatar(asset: String) -> some View {
        Image(asset)
            .resizable()
            .scaledToFill()
            .frame(width: 30, height: 30)
            .clipShape(Circle())
    }

    @ViewBuilder
    private var bubble: some View {
        if message.isOutgoing {
            outgoingBubble
        } else {
            incomingBubble
        }
    }

    private var incomingBubble: some View {
        Text(message.text)
            .font(AppTypography.bodySmMedium)
            .foregroundStyle(AppColors.mainBlack)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                BubbleShape(isOutgoing: false)
                    .fill(Color(hex: 0xF2F5F9))
            )
            .frame(maxWidth: 260, alignment: .leading)
    }

    private var outgoingBubble: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(message.text)
                .font(AppTypography.bodySmMedium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Image(AppVectors.chatSeenCheck)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .opacity(message.isSeen ? 1 : 0.4)
                Spacer()
                Text(message.time)
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            BubbleShape(isOutgoing: true)
                .fill(AppColors.brand)
        )
        .frame(maxWidth: 260, alignment: .trailing)
    }
}

/// Speech-bubble shape with a small tail on the bottom corner — leading
/// (incoming) or trailing (outgoing). Pure SwiftUI path so it scales with
/// the text without raster artefacts.
private struct BubbleShape: Shape {
    let isOutgoing: Bool
    var cornerRadius: CGFloat = 14
    var tailWidth: CGFloat = 9
    var tailHeight: CGFloat = 9

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = cornerRadius
        let body = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        p.addRoundedRect(in: body, cornerSize: CGSize(width: r, height: r))

        if isOutgoing {
            let tipX = rect.maxX + tailWidth
            let tipY = rect.maxY - 2
            p.move(to: CGPoint(x: rect.maxX - 2, y: rect.maxY - tailHeight - 2))
            p.addLine(to: CGPoint(x: tipX, y: tipY))
            p.addLine(to: CGPoint(x: rect.maxX - 2, y: rect.maxY - 2))
            p.closeSubpath()
        } else {
            let tipX = -tailWidth
            let tipY = rect.maxY - 2
            p.move(to: CGPoint(x: 2, y: rect.maxY - tailHeight - 2))
            p.addLine(to: CGPoint(x: tipX, y: tipY))
            p.addLine(to: CGPoint(x: 2, y: rect.maxY - 2))
            p.closeSubpath()
        }

        return p
    }
}
