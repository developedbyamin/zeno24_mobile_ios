import SwiftUI
import UIKit

/// Shared lavender backdrop used by the Circle picker (Figma 5421:8762) and
/// the Notifications filter (Figma 5421:8435). Both Figma frames specify an
/// 8pt `backdrop-blur` layered with a translucent lavender gradient (0.7
/// opacity). iOS materials top out far heavier than that, so this view wraps
/// `UIVisualEffectView` with a paused `UIViewPropertyAnimator` to dial the
/// `systemUltraThinMaterial` blur down to ~30% strength — close to the 8pt
/// radius the design calls for.
struct LavenderBlurBackdrop: View {
    var body: some View {
        ZStack {
            LavenderBackdropBlurView()
            LinearGradient(
                colors: [
                    Color(red: 249/255, green: 241/255, blue: 251/255).opacity(0.7),
                    Color(red: 207/255, green: 189/255, blue: 211/255).opacity(0.7),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }
}

private struct LavenderBackdropBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: nil)
        context.coordinator.animator?.stopAnimation(true)
        let animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            view.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        }
        animator.fractionComplete = 0.30
        animator.pausesOnCompletion = true
        context.coordinator.animator = animator
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}

    static func dismantleUIView(_ uiView: UIVisualEffectView, coordinator: Coordinator) {
        coordinator.animator?.stopAnimation(true)
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator {
        var animator: UIViewPropertyAnimator?
        deinit { animator?.stopAnimation(true) }
    }
}
