import SwiftUI
import CoreImage.CIFilterBuiltins
import UIKit

struct InviteMemberSheet: View {
    @Binding var isPresented: Bool
    let circleId: String
    let avatarUrl: String?
    let invite: (String) async throws -> InviteCircleResponseModel
    var initialCode: String?
    var initialQRBase64: String?
    var initialLink: String?

    var body: some View {
        BottomSheetContainer(
            isPresented: $isPresented,
            panelFill: Self.backgroundGradient
        ) { _ in
            InvitePanel(
                circleId: circleId,
                avatarUrl: avatarUrl,
                invite: invite,
                initialCode: initialCode,
                initialQRBase64: initialQRBase64,
                initialLink: initialLink
            )
        }
    }

    fileprivate static let backgroundGradient = LinearGradient(
        stops: [
            .init(color: Color(red: 0xCC/255, green: 0x89/255, blue: 0xF7/255), location: 0.094),
            .init(color: Color(red: 0xAC/255, green: 0x79/255, blue: 0xF2/255), location: 0.566),
            .init(color: Color(red: 0xA6/255, green: 0x8C/255, blue: 0xF7/255), location: 1),
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Panel

private struct InvitePanel: View {
    let circleId: String
    let avatarUrl: String?
    let invite: (String) async throws -> InviteCircleResponseModel
    var initialCode: String?
    var initialQRBase64: String?
    var initialLink: String?

    @Environment(\.dismissBottomSheet) private var dismissBottomSheet
    @State private var inviteCode: String = ""
    @State private var qrBase64: String?
    @State private var shareLink: String?
    @State private var isLoading: Bool = true
    @State private var copiedFlash: Bool = false
    @State private var copiedHideTask: Task<Void, Never>?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Spacer().frame(height: 24)
                titleBlock
                    .padding(.horizontal, 16)
                Spacer().frame(height: 32)
                qrCard
                Spacer().frame(height: 24)
                dividerRow
                    .padding(.horizontal, 16)
                Spacer().frame(height: 8)
                codeBox
                    .padding(.horizontal, 16)
                Spacer().frame(height: 16)
                ctaButtons
                    .padding(.horizontal, 16)
                Spacer().frame(height: 32)
            }

            closeButton
                .padding(.top, 16)
                .padding(.trailing, 12)
        }
        .task {
            await loadInvite()
        }
    }

    // MARK: - Title

    private var titleBlock: some View {
        VStack(spacing: 8) {
            Text("Invite to Your Circle")
                .font(AppTypography.headingXsSemiBold)
                .foregroundStyle(.white)
            Text("Add your family or friends to your circle")
                .font(AppTypography.bodySmMedium)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - QR card

    private var qrCard: some View {
        ZStack {
            ZStack {
                if let img = qrImage {
                    Image(uiImage: img)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 236, height: 236)
                } else if isLoading {
                    Skeleton()
                        .frame(width: 236, height: 236)
                }

                ZStack {
                    Circle().fill(Color(hex: 0xF8F7FF))
                        .frame(width: 56, height: 56)
                    avatarView
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                }
            }
            .frame(width: 260, height: 264)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .frame(width: 276, height: 280)
        .background(Color.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
    }

    @ViewBuilder
    private var avatarView: some View {
        if let urlStr = avatarUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { img in
                img.resizable().scaledToFill()
            } placeholder: {
                Color(hex: 0xEDBBD6)
            }
        } else {
            Color(hex: 0xEDBBD6)
        }
    }

    // MARK: - Divider row

    private var dividerRow: some View {
        HStack(spacing: 8) {
            Rectangle().fill(Color.white.opacity(0.3)).frame(height: 1)
            Text("or use code")
                .font(AppTypography.bodyXsMedium)
                .foregroundStyle(.white)
            Rectangle().fill(Color.white.opacity(0.3)).frame(height: 1)
        }
        .frame(height: 16)
    }

    // MARK: - Code box

    private var codeBox: some View {
        ZStack {
            Text(formatted(inviteCode))
                .font(.custom("PlusJakartaSans-SemiBold", size: 32))
                .foregroundStyle(AppColors.mainBlack)
                .opacity(isLoading ? 0 : (copiedFlash ? 0 : 1))

            if isLoading {
                Skeleton()
                    .frame(width: 180, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            VStack(spacing: 4) {
                Text("Copied  🎉")
                    .font(.custom("PlusJakartaSans-Bold", size: 28))
                    .foregroundStyle(AppColors.mainBlack)
                Text("This code is valid for 2 hours")
                    .font(AppTypography.bodyXsSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
            }
            .opacity(copiedFlash ? 1 : 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 76)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .padding(6)
        .background(Color.white.opacity(0.16), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture { handleCodeTap() }
    }

    // MARK: - CTAs

    private var ctaButtons: some View {
        VStack(spacing: 12) {
            Button(action: handleSendInvite) {
                Text("Send Invite Code")
                    .font(AppTypography.bodySmBold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppColors.mainBlack, in: Capsule())
                    .opacity(isLoading ? 0.6 : 1)
            }
            .buttonStyle(InvitePressStyle())
            .disabled(isLoading)

            Button(action: { dismiss() }) {
                Text("Send later")
                    .font(AppTypography.bodySmBold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white.opacity(0.2), in: Capsule())
            }
            .buttonStyle(InvitePressStyle())
        }
    }

    // MARK: - Close

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(AppVectors.closeSmall)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(Color.white.opacity(0.2), in: Circle())
        }
        .buttonStyle(InvitePressStyle())
    }

    // MARK: - Actions

    private func loadInvite() async {
        if let initialCode, !initialCode.isEmpty {
            inviteCode = initialCode
            qrBase64 = initialQRBase64
            shareLink = initialLink
            isLoading = false
            return
        }
        isLoading = true
        do {
            let response = try await invite(circleId)
            inviteCode = response.code ?? ""
            qrBase64 = response.qr
            shareLink = response.link
            isLoading = false
        } catch {
            OverlayHelper.shared.showFailure(error)
            isLoading = false
            dismiss()
        }
    }

    private func handleCodeTap() {
        let cleaned = inviteCode.filter { !$0.isWhitespace && $0 != "-" }
        guard !cleaned.isEmpty else { return }
        UIPasteboard.general.string = cleaned

        copiedHideTask?.cancel()
        withAnimation(.easeOut(duration: 0.18)) { copiedFlash = true }
        copiedHideTask = Task {
            try? await Task.sleep(for: .seconds(3))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                withAnimation(.easeIn(duration: 0.22)) { copiedFlash = false }
            }
        }
    }

    private func handleSendInvite() {
        guard !isLoading else { return }
        let code = inviteCode
        if let link = shareLink, !link.isEmpty {
            presentShareSheet(text: shareMessage(link: link, code: code))
        } else {
            dismiss()
        }
    }

    private func dismiss() {
        copiedHideTask?.cancel()
        dismissBottomSheet()
    }

    private func shareMessage(link: String, code: String) -> String {
        "Join my circle on Zeno24. Use code \(code) or open \(link)"
    }

    private func presentShareSheet(text: String) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.keyWindow?.rootViewController else { return }
        let topMost = topMostController(root)
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let popover = activity.popoverPresentationController {
            popover.sourceView = topMost.view
            popover.sourceRect = CGRect(x: topMost.view.bounds.midX,
                                        y: topMost.view.bounds.midY,
                                        width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        topMost.present(activity, animated: true)
    }

    private func topMostController(_ base: UIViewController) -> UIViewController {
        if let presented = base.presentedViewController { return topMostController(presented) }
        return base
    }

    // MARK: - Helpers

    private func formatted(_ code: String) -> String {
        let cleaned = code.filter { !$0.isWhitespace && $0 != "-" }
        guard cleaned.count == 6 else { return code }
        let mid = cleaned.index(cleaned.startIndex, offsetBy: 3)
        return "\(cleaned[..<mid]) - \(cleaned[mid...])"
    }

    private var qrImage: UIImage? {
        if let qrBase64, let img = imageFromBase64(qrBase64) { return img }
        guard !inviteCode.isEmpty else { return nil }
        return generateQR(content: inviteCode)
    }

    private func imageFromBase64(_ raw: String) -> UIImage? {
        var payload = raw
        if let commaIdx = payload.firstIndex(of: ",") {
            payload = String(payload[payload.index(after: commaIdx)...])
        }
        guard let data = Data(base64Encoded: payload, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: data)
    }

    private func generateQR(content: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(content.utf8)
        filter.correctionLevel = "H"
        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cg = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cg)
    }
}

// MARK: - Skeleton

private struct Skeleton: View {
    @State private var animating = false

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let base = Color(hex: 0xF2F5F9)
            let highlight = Color.white.opacity(0.9)
            Rectangle()
                .fill(LinearGradient(
                    colors: [base, highlight, base],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(width: w * 2)
                .offset(x: animating ? w * 0.5 : -w * 1.5)
                .onAppear {
                    withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                        animating = true
                    }
                }
        }
        .clipped()
        .background(Color(hex: 0xF2F5F9))
    }
}

// MARK: - Press style

private struct InvitePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - UIWindowScene.keyWindow helper

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first(where: \.isKeyWindow) ?? windows.first }
}
