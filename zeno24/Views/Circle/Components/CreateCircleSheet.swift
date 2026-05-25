import SwiftUI

/// Full-screen "Create a Circle" overlay — 1:1 SwiftUI port of the Flutter
/// project's UIKit `HomeCreateCircleOverlay`.
///
/// Behaviour parity:
///   • Full-screen panel with bottom-only 30 pt radius (same backdrop as
///     `CirclePickerSheet`: ultraThinMaterial α 0.7 + purple→pink gradient).
///   • Header white capsule (48 pt): 32 pt gray back chip on the left, brand
///     icon + "Create a Circle" centered.
///   • Single white card containing one centered text field. Empty placeholder
///     = Medium 20 pt gray; typed text = Bold 28 pt main-black.
///   • Brand-purple "Save" button (52 pt). Pressing it disables the form and
///     shows a spinner inside the button until the API resolves.
///   • Backdrop tap / back chip = dismiss (only when not loading).
///   • Error returned by the API is shown as a small inline banner above the
///     save button so the user knows what went wrong (Flutter equivalent of
///     the snackbar/toast).
///   • Save card respects the keyboard — content shifts up so the field stays
///     visible while typing.
struct CreateCircleSheet: View {
    @Binding var isPresented: Bool
    @Environment(CirclesStore.self) private var circles

    @State private var name: String = ""
    @State private var isLoading: Bool = false
    @FocusState private var nameFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            // 1. Background — full-screen, bottom-only 30pt radius. Tap = dismiss.
            backgroundShape
                .ignoresSafeArea()
                .contentShape(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(bottomLeading: 30, bottomTrailing: 30),
                        style: .continuous
                    )
                )
                .onTapGesture { dismiss() }

            // 2. Content stack — header + text card + save (keyboard-aware).
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
            // Mirror Flutter — focus the field as soon as the overlay appears
            // so the keyboard slides up immediately.
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
            // Center: icon + title
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

            // Leading back chip
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
        .onTapGesture { /* consume */ }
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
                // Same toast pipeline as Auth (SignView / OtpView / CreateNameView).
                OverlayHelper.shared.showFailure(error)
            }
        }
    }

    private func dismiss() {
        guard !isLoading else { return }
        nameFocused = false
        // Symmetric with the open animation so the cross-fade against the
        // picker behind us is perfectly even.
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
