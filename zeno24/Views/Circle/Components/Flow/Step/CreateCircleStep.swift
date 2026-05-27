import SwiftUI

struct CreateCircleStep: View {
    var onBack: () -> Void
    var onCompleted: () -> Void

    @Environment(CirclesStore.self) private var circles

    @State private var name: String = ""
    @State private var isLoading: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var nameFocused: Bool

    var body: some View {
        GeometryReader { proxy in
            let usableHeight = proxy.size.height
                - max(0, keyboardHeight - proxy.safeAreaInsets.bottom)

            VStack(spacing: 8) {
                FlowHeaderPill(
                    title: "Create a Circle",
                    leadingIcon: AppVectors.circleGridInterface,
                    disabled: isLoading,
                    onBack: handleBack
                )
                textCard
                saveButton
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
            nameFocused = true
        }
    }

    // MARK: - Text card

    private var textCard: some View {
        TextField("", text: $name, prompt: placeholder)
            .font(.custom("PlusJakartaSans-Bold", size: 28))
            .foregroundStyle(AppColors.mainBlack)
            .multilineTextAlignment(.center)
            .focused($nameFocused)
            .disabled(isLoading)
            .submitLabel(.done)
            .onSubmit { attemptSave() }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .onTapGesture { nameFocused = true }
    }

    private var placeholder: Text {
        Text("Enter your circle name")
            .font(.custom("PlusJakartaSans-Medium", size: 20))
            .foregroundColor(AppColors.textMuted)
    }

    // MARK: - Save

    private var saveButton: some View {
        Button(action: attemptSave) {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Save")
                        .font(AppTypography.bodySmBold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: CircleFlowMetrics.primaryButtonHeight)
            .background(AppColors.brand, in: Capsule())
            .opacity(isLoading ? 0.85 : 1.0)
        }
        .buttonStyle(ScalePressStyle())
        .disabled(isLoading)
    }

    // MARK: - Actions

    private func attemptSave() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isLoading else {
            if trimmed.isEmpty { nameFocused = true }
            return
        }
        nameFocused = false
        Task {
            isLoading = true
            do {
                try await circles.add(name: trimmed)
                isLoading = false
                onCompleted()
            } catch {
                isLoading = false
                OverlayHelper.shared.showFailure(error)
            }
        }
    }

    private func handleBack() {
        guard !isLoading else { return }
        nameFocused = false
        onBack()
    }
}
