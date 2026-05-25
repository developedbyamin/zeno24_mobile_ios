import SwiftUI

struct CreateCircleSheet: View {
    @Binding var isPresented: Bool
    @Environment(CirclesStore.self) private var circles

    @State private var name: String = ""
    @State private var isLoading: Bool = false
    @FocusState private var nameFocused: Bool

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
                textCard
                saveButton
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                nameFocused = true
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
            HStack(spacing: 8) {
                Image(AppVectors.circleGridInterface)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(AppColors.brand)
                Text("Create a Circle")
                    .font(AppTypography.bodySmSemiBold)
                    .foregroundStyle(AppColors.mainBlack)
            }

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
                .buttonStyle(OverlayPressStyle())
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

    // MARK: - Text card

    private var textCard: some View {
        ZStack {
            TextField("", text: $name, prompt: placeholder)
                .font(.custom("PlusJakartaSans-Bold", size: 28))
                .foregroundStyle(AppColors.mainBlack)
                .multilineTextAlignment(.center)
                .focused($nameFocused)
                .disabled(isLoading)
                .submitLabel(.done)
                .onSubmit { attemptSave() }
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture { nameFocused = true }
    }

    private var placeholder: Text {
        Text("Enter your circle name")
            .font(.custom("PlusJakartaSans-Medium", size: 20))
            .foregroundColor(Color(hex: 0x8B98A8))
    }

    // MARK: - Save

    private var saveButton: some View {
        Button {
            attemptSave()
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Save")
                        .font(AppTypography.bodySmBold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(AppColors.brand, in: Capsule())
            .opacity(isLoading ? 0.85 : 1.0)
        }
        .buttonStyle(OverlayPressStyle())
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
                dismiss()
            } catch {
                isLoading = false
                OverlayHelper.shared.showFailure(error)
            }
        }
    }

    private func dismiss() {
        guard !isLoading else { return }
        nameFocused = false
        withAnimation(.easeInOut(duration: 0.28)) {
            isPresented = false
        }
    }
}

// MARK: - Press style

private struct OverlayPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
