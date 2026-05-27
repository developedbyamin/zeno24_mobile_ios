import SwiftUI

struct JoinCircleStep: View {
    var onBack: () -> Void
    var onInvitationLoaded: (_ code: String, _ info: InfoCircleResponseModel) -> Void

    @Environment(CirclesStore.self) private var circles

    @State private var code: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var codeFocused: Bool

    var body: some View {
        GeometryReader { proxy in
            let usableHeight = proxy.size.height
                - max(0, keyboardHeight - proxy.safeAreaInsets.bottom)

            VStack(spacing: 8) {
                FlowHeaderPill(
                    title: "Join a Circle",
                    disabled: isLoading,
                    onBack: handleBack
                )
                codeCard
                continueButton
            }
            .padding(.horizontal, CircleFlowMetrics.contentHorizontalPadding)
            .padding(.top, CircleFlowMetrics.contentTopPadding)
            .padding(.bottom, CircleFlowMetrics.contentBottomPadding)
            .frame(
                width: proxy.size.width,
                height: max(0, usableHeight),
                alignment: .top
            )
            .animation(.easeOut(duration: 0.25), value: keyboardHeight)
        }
        .keyboardHeight($keyboardHeight)
        .task {
            try? await Task.sleep(for: CircleFlowMetrics.focusDelay)
            codeFocused = true
        }
    }

    // MARK: - Code card

    private var codeCard: some View {
        VStack(spacing: 16) {
            slotsRow
                .offset(x: shakeOffset)
                .overlay(hiddenField)
            hintBadge
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture { codeFocused = true }
    }

    private var slotsRow: some View {
        HStack(spacing: 12) {
            ForEach(0..<CircleFlowMetrics.codeLength, id: \.self) { index in
                CodeSlot(
                    digit: digitAt(index),
                    filled: index < code.count,
                    focused: codeFocused
                        && index == min(code.count, CircleFlowMetrics.codeLength - 1)
                        && code.count < CircleFlowMetrics.codeLength
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
                    .foregroundStyle(AppColors.mainBlack, AppColors.warningSoft)
                    .font(.system(size: 14))
            }
            Text(showError ? "Incorrect code" : "Ask the Circle owner for the code")
                .font(AppTypography.bodyXsSemiBold)
                .foregroundStyle(AppColors.mainBlack)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.surfaceMuted, in: Capsule())
    }

    private var hiddenField: some View {
        TextField("", text: Binding(
            get: { code },
            set: { newValue in
                let digits = String(newValue.filter { $0.isNumber }.prefix(CircleFlowMetrics.codeLength))
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
        Button(action: attemptJoin) {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Continue")
                        .font(AppTypography.bodySmBold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: CircleFlowMetrics.primaryButtonHeight)
            .background(AppColors.brand, in: Capsule())
            .opacity(isComplete ? 1.0 : 0.5)
        }
        .buttonStyle(ScalePressStyle())
        .disabled(!isComplete || isLoading)
    }

    private var isComplete: Bool { code.count == CircleFlowMetrics.codeLength }

    // MARK: - Actions

    private func attemptJoin() {
        guard isComplete, !isLoading else { return }
        codeFocused = false
        let submitted = code
        Task {
            isLoading = true
            do {
                let info = try await circles.info(code: submitted)
                isLoading = false
                onInvitationLoaded(submitted, info)
            } catch {
                isLoading = false
                await triggerError()
            }
        }
    }

    @MainActor
    private func triggerError() async {
        withAnimation(.easeInOut(duration: 0.18)) { showError = true }
        let amp = CircleFlowMetrics.codeShakeAmplitude
        let steps: [CGFloat] = [-amp, amp, -amp * 0.6, amp * 0.6, 0]
        for step in steps {
            try? await Task.sleep(for: .milliseconds(100))
            withAnimation(.linear(duration: 0.1)) { shakeOffset = step }
        }
        try? await Task.sleep(for: .milliseconds(50))
        code = ""
        codeFocused = true
    }

    private func handleBack() {
        guard !isLoading else { return }
        codeFocused = false
        onBack()
    }
}

// MARK: - Single digit slot

private struct CodeSlot: View {
    let digit: String
    let filled: Bool
    let focused: Bool

    @State private var caretOpacity: Double = 1.0

    private var emptyDigitColor: Color { AppColors.textMuted.opacity(0.4) }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                if focused {
                    Rectangle()
                        .fill(AppColors.brand)
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
                        .foregroundStyle(filled ? AppColors.brand : emptyDigitColor)
                }
            }
            .frame(height: 36)

            Rectangle()
                .fill(focused || filled ? AppColors.brand : AppColors.surfaceMuted)
                .frame(height: 1)
                .cornerRadius(0.5)
        }
        .frame(maxWidth: .infinity)
    }
}
