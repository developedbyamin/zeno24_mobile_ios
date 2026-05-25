import SwiftUI

struct JoinCircleSheet: View {
    @Binding var isPresented: Bool
    @Environment(CirclesStore.self) private var circles
    var onInvitationLoaded: (_ code: String, _ info: InfoCircleResponseModel) -> Void = { _, _ in }

    @State private var code: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @FocusState private var codeFocused: Bool

    private static let codeLength = 6

    var body: some View {
        ZStack(alignment: .top) {
            backgroundShape
                .ignoresSafeArea()
                .contentShape(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
                        style: .continuous
                    )
                )
                .onTapGesture { dismiss() }

            VStack(spacing: 8) {
                headerPill
                codeCard
                continueButton
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                codeFocused = true
            }
        }
    }

    // MARK: - Background

    private var backgroundShape: some View {
        UnevenRoundedRectangle(
            cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
            style: .continuous
        )
        .fill(.ultraThinMaterial)
        .opacity(0.7)
        .overlay(
            UnevenRoundedRectangle(
                cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
                style: .continuous
            )
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0xF9/255, green: 0xF1/255, blue: 0xFB/255).opacity(0.7),
                        Color(red: 0xCF/255, green: 0xBD/255, blue: 0xD3/255).opacity(0.7),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        )
    }

    // MARK: - Header pill

    private var headerPill: some View {
        ZStack {
            Text("Join a Circle")
                .font(AppTypography.bodySmSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(AppVectors.backArrow)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(AppColors.mainBlack)
                        .frame(width: 32, height: 32)
                        .background(Color(hex: 0xF2F5F9), in: Circle())
                }
                .buttonStyle(JoinPressStyle())
                .disabled(isLoading)
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 48)
        .background(Color.white, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.white, lineWidth: 1))
        .contentShape(Capsule())
        .onTapGesture { }
    }

    // MARK: - Code card

    private var codeCard: some View {
        VStack(spacing: 16) {
            slotsRow
                .offset(x: shakeOffset)
            hintBadge
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture { codeFocused = true }
        .overlay(hiddenField)
    }

    private var slotsRow: some View {
        HStack(spacing: 12) {
            ForEach(0..<Self.codeLength, id: \.self) { index in
                CodeSlotView(
                    digit: digitAt(index),
                    filled: index < code.count,
                    focused: codeFocused && index == min(code.count, Self.codeLength - 1) && code.count < Self.codeLength
                )
            }
        }
        .frame(height: 56)
    }

    private func digitAt(_ index: Int) -> String {
        let chars = Array(code)
        return index < chars.count ? String(chars[index]) : "-"
    }

    private var hintBadge: some View {
        HStack(spacing: 8) {
            if showError {
                Image(systemName: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        AppColors.mainBlack,
                        Color(red: 0xFA/255, green: 0xB9/255, blue: 0x23/255)
                    )
                    .font(.system(size: 14))
            }
            Text(showError ? "Incorrect code" : "Ask the Circle owner for the code")
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(AppColors.mainBlack)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(hex: 0xF2F5F9), in: Capsule())
    }

    private var hiddenField: some View {
        TextField("", text: Binding(
            get: { code },
            set: { newValue in
                let digits = String(newValue.filter { $0.isNumber }.prefix(Self.codeLength))
                if showError && !digits.isEmpty {
                    withAnimation(.easeInOut(duration: 0.18)) { showError = false }
                }
                code = digits
            }
        ))
        .keyboardType(.numberPad)
        .textContentType(.oneTimeCode)
        .focused($codeFocused)
        .disabled(isLoading)
        .foregroundStyle(Color.clear)
        .tint(Color.clear)
        .frame(width: 1, height: 1)
        .opacity(0.01)
        .allowsHitTesting(false)
    }

    // MARK: - Continue

    private var continueButton: some View {
        Button {
            attemptJoin()
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Continue")
                        .font(AppTypography.bodySmBold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(AppColors.brand, in: Capsule())
            .opacity(isComplete ? 1.0 : 0.5)
        }
        .buttonStyle(JoinPressStyle())
        .disabled(!isComplete || isLoading)
    }

    private var isComplete: Bool { code.count == Self.codeLength }

    // MARK: - Actions

    private func attemptJoin() {
        guard isComplete, !isLoading else { return }
        codeFocused = false
        let submitted = code
        Task {
            isLoading = true
            do {
                // Code-u backend-də yoxlamaq + circle preview almaq üçün
                // `/circles/info` chağırılır. Real `/circles/join` yalnız
                // invitation sheet-də "Join" basıldıqdan sonra göndərilir
                // (1:1 Flutter HomeJoinCircleOverlay → HomeJoinInvitationOverlay
                // ardıcıllığı).
                let info = try await circles.info(code: submitted)
                isLoading = false
                onInvitationLoaded(submitted, info)
            } catch {
                isLoading = false
                triggerError()
            }
        }
    }

    private func triggerError() {
        withAnimation(.easeInOut(duration: 0.18)) { showError = true }
        // Horizontal shake mirroring the Flutter overlay's CAKeyframeAnimation.
        let amplitude: CGFloat = 8
        let steps: [CGFloat] = [-amplitude, amplitude, -amplitude * 0.6, amplitude * 0.6, 0]
        for (i, step) in steps.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(i + 1)) {
                withAnimation(.linear(duration: 0.1)) { shakeOffset = step }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            code = ""
            codeFocused = true
        }
    }

    private func dismiss() {
        guard !isLoading else { return }
        codeFocused = false
        withAnimation(.easeInOut(duration: 0.28)) {
            isPresented = false
        }
    }
}

// MARK: - Single digit slot

private struct CodeSlotView: View {
    let digit: String
    let filled: Bool
    let focused: Bool

    @State private var caretOpacity: Double = 1.0

    private let filledColor = Color(hex: 0x9171F4)
    private let emptyColor = Color(hex: 0xF2F5F9)
    private let emptyDigitColor = Color(hex: 0x8B98A8).opacity(0.4)

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                if focused {
                    Rectangle()
                        .fill(filledColor)
                        .frame(width: 2, height: 28)
                        .cornerRadius(1)
                        .opacity(caretOpacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true)) {
                                caretOpacity = 0
                            }
                        }
                        .onDisappear { caretOpacity = 1.0 }
                } else {
                    Text(digit)
                        .font(.custom("PlusJakartaSans-Bold", size: 28))
                        .foregroundStyle(filled ? filledColor : emptyDigitColor)
                }
            }
            .frame(height: 36)

            Rectangle()
                .fill(focused || filled ? filledColor : emptyColor)
                .frame(height: 1)
                .cornerRadius(0.5)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Press style

private struct JoinPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
