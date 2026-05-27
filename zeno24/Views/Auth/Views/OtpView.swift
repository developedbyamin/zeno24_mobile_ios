import SwiftUI

struct OtpView: View {
    @Environment(AuthStore.self) private var store
    @State private var vm = OtpViewModel()
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        @Bindable var store = store
        AuthScreen {
            VStack(spacing: 0) {
                AuthHeader(isVisible: true, onBack: { store.goBack() }) {
                    AuthAnimatedIcon(source: .asset(AppImages.emojiLocked))
                }
                .padding(.top, 16)

                Spacer().frame(height: 20)

                OtpVerificationHeader(
                    channel: store.lastOtpChannel,
                    isRegistered: store.isRegistered,
                    maskedContact: store.maskedContact,
                    formattedContact: store.contactDisplay,
                    rawEmail: store.email
                )

                Spacer().frame(height: 24)

                OtpTimerPill(
                    formatted: vm.countdown.formatted,
                    isVisible: !vm.countdown.isFinished
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

                OtpResendRow(isEnabled: vm.countdown.isFinished) {
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
            .opacity(vm.didAppear ? 1 : 0)
            .offset(y: vm.didAppear ? 0 : 8)
            .animation(.easeOut(duration: 0.28), value: vm.didAppear)
        }
        .task {
            await vm.onAppear()
            isFieldFocused = true
        }
        .onAppear { vm.startCountdown() }
        .onDisappear { vm.stopCountdown() }
        .onChange(of: store.otpResendNonce) { _, _ in vm.startCountdown() }
        .onChange(of: store.errorMessage) { _, message in
            guard let message else { return }
            OverlayHelper.shared.show(message, kind: .error)
            store.errorMessage = nil
        }
    }
}
