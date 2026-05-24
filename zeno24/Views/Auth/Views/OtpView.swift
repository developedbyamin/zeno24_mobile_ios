import SwiftUI

/// Step 2 — 6-digit OTP entry. Figma node `4024:6256` (Enter email).
/// Single layout for both phone (WhatsApp) and email channels.
struct OtpView: View {
    @Environment(AuthStore.self) private var store
    @State private var didAppear = false
    @State private var countdown = OtpCountdown(seconds: 0)
    @FocusState private var isFieldFocused: Bool

    private let resendCooldown = 120

    var body: some View {
        @Bindable var store = store
        AuthScreen {
            VStack(spacing: 0) {
                AuthHeader(isVisible: true, onBack: { store.goBack() }) {
                    AuthAnimatedIcon(source: .asset(AppImages.emojiLocked))
                }
                .padding(.top, 16)

                Spacer().frame(height: 20)

                OtpVerificationHeader(channel: store.lastOtpChannel)

                Spacer().frame(height: 24)

                OtpTimerPill(
                    formatted: countdown.formatted,
                    isVisible: !countdown.isFinished
                )

                Spacer().frame(height: 24)

                OtpInputSection(store: store, focus: $isFieldFocused) {
                    Task { await store.verifyOtp() }
                }

                ZStack {
                    if store.showOtpError {
                        OtpErrorPill(message: AppStrings.Auth.Otp.incorrect)
                            .transition(.opacity)
                    }
                }
                .frame(height: 32)
                .padding(.top, 16)
                .animation(.smooth(duration: 0.22), value: store.showOtpError)

                Spacer()

                OtpResendRow(isEnabled: countdown.isFinished) {
                    Task { await store.resendOtp() }
                }
                .padding(.bottom, 12)

                AuthCTAButton(
                    title: AppStrings.Common.continue,
                    isEnabled: store.isOtpValid,
                    isLoading: store.isSubmitting
                ) {
                    Task { await store.verifyOtp() }
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 16)
            .opacity(didAppear ? 1 : 0)
            .offset(y: didAppear ? 0 : 8)
            .animation(.easeOut(duration: 0.28), value: didAppear)
        }
        .task {
            await Task.yield()
            didAppear = true
            try? await Task.sleep(for: .milliseconds(400))
            isFieldFocused = true
        }
        .onAppear { countdown.start(from: resendCooldown) }
        .onDisappear { countdown.stop() }
        .onChange(of: store.otpResendNonce) { _, _ in
            countdown.start(from: resendCooldown)
        }
        .onChange(of: store.errorMessage) { _, message in
            guard let message else { return }
            OverlayHelper.shared.show(message, kind: .error)
            store.errorMessage = nil
        }
    }
}
