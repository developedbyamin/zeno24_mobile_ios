import SwiftUI
import UIKit

/// Flutter `showModalBottomSheet` equivalent built on top of the existing
/// UIKit pattern (`HomeInviteCircleSheetContainerVC` from the Flutter iOS
/// runner). Internally the SwiftUI content is hosted inside a UIKit
/// `BottomSheetCardContainerVC` presented `.overFullScreen` — that gives
/// us:
///
///   • Native `UIPanGestureRecognizer` drag-to-dismiss that composes
///     correctly with child Button taps (no SwiftUI gesture priority
///     gymnastics).
///   • A real UIKit modal so the gradient/background bleeds to the screen
///     edge below the home indicator without safe-area workarounds.
///   • Spring slide-up / ease-out slide-down matching the Flutter port.
///
/// API surface stays SwiftUI-native: mount this view inside a parent
/// ZStack via `if isPresented { BottomSheetContainer(...) }` and the
/// representable below drives the UIKit presentation lifecycle.
struct BottomSheetContainer<Content, Fill>: View where Content: View, Fill: ShapeStyle {
    @Binding var isPresented: Bool
    var topCornerRadius: CGFloat = 30
    var backdropOpacity: Double = 0.4
    let panelFill: Fill
    let content: (BottomSheetDismissAction) -> Content

    init(
        isPresented: Binding<Bool>,
        topCornerRadius: CGFloat = 30,
        backdropOpacity: Double = 0.4,
        panelFill: Fill,
        @ViewBuilder content: @escaping (BottomSheetDismissAction) -> Content
    ) {
        self._isPresented = isPresented
        self.topCornerRadius = topCornerRadius
        self.backdropOpacity = backdropOpacity
        self.panelFill = panelFill
        self.content = content
    }

    var body: some View {
        _BottomSheetPresenter(
            isPresented: $isPresented,
            topCornerRadius: topCornerRadius,
            backdropOpacity: backdropOpacity
        ) { dismissAction in
            AnyView(
                content(dismissAction)
                    .environment(\.dismissBottomSheet, dismissAction)
                    .frame(maxWidth: .infinity)
                    .background(
                        Rectangle()
                            .fill(panelFill)
                            .ignoresSafeArea(.container, edges: .bottom)
                    )
            )
        }
        .frame(width: 0, height: 0)
    }
}

// MARK: - Dismiss action

struct BottomSheetDismissAction {
    private let action: (@escaping () -> Void) -> Void
    init(_ action: @escaping (@escaping () -> Void) -> Void) { self.action = action }

    /// Dismiss without a completion callback.
    func callAsFunction() { action({}) }

    /// Dismiss and run `completion` after the slide-down animation
    /// + UIKit dismissal finish. Use this when you need to open a
    /// follow-on sheet (e.g. role → invite) so the new modal isn't
    /// presented on top of the still-dismissing card.
    func callAsFunction(then completion: @escaping () -> Void) { action(completion) }
}

private struct BottomSheetDismissKey: EnvironmentKey {
    static let defaultValue = BottomSheetDismissAction { completion in completion() }
}

extension EnvironmentValues {
    var dismissBottomSheet: BottomSheetDismissAction {
        get { self[BottomSheetDismissKey.self] }
        set { self[BottomSheetDismissKey.self] = newValue }
    }
}

// MARK: - SwiftUI ↔ UIKit bridge

private struct _BottomSheetPresenter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let topCornerRadius: CGFloat
    let backdropOpacity: Double
    let buildContent: (BottomSheetDismissAction) -> AnyView

    init(
        isPresented: Binding<Bool>,
        topCornerRadius: CGFloat,
        backdropOpacity: Double,
        buildContent: @escaping (BottomSheetDismissAction) -> AnyView
    ) {
        self._isPresented = isPresented
        self.topCornerRadius = topCornerRadius
        self.backdropOpacity = backdropOpacity
        self.buildContent = buildContent
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIViewController(context: Context) -> _BottomSheetTriggerVC {
        _BottomSheetTriggerVC()
    }

    func updateUIViewController(_ uiViewController: _BottomSheetTriggerVC, context: Context) {
        context.coordinator.sync(
            isPresented: isPresented,
            topCornerRadius: topCornerRadius,
            backdropOpacity: backdropOpacity,
            buildContent: buildContent,
            onDismissed: {
                // Avoid feedback loops: only flip if SwiftUI still thinks
                // the sheet is presented.
                if isPresented { isPresented = false }
            }
        )
    }

    static func dismantleUIViewController(_ uiViewController: _BottomSheetTriggerVC,
                                          coordinator: Coordinator) {
        coordinator.dismantle()
    }

    final class Coordinator {
        // Strong reference — without it the freshly-built card is
        // deallocated before the deferred `present(_:animated:)` call
        // (`DispatchQueue.main.async`) ever runs, and the modal silently
        // never appears.
        private var presentedVC: BottomSheetCardContainerVC?
        // Latches once a dismiss is initiated and clears only when SwiftUI
        // settles the binding back to `false`. Without it, a SwiftUI
        // re-render that lands while the card is mid-dismiss would see
        // `presentedVC == nil` + `isPresented == true` and re-present the
        // sheet (this is exactly what made the role sheet's back button
        // appear to "reopen" itself).
        private var isDismissing = false

        func sync(
            isPresented: Bool,
            topCornerRadius: CGFloat,
            backdropOpacity: Double,
            buildContent: (BottomSheetDismissAction) -> AnyView,
            onDismissed: @escaping () -> Void
        ) {
            if isPresented {
                if presentedVC != nil || isDismissing { return }

                let dismissAction = BottomSheetDismissAction { [weak self] completion in
                    guard let self, let card = self.presentedVC else {
                        completion()
                        return
                    }
                    self.isDismissing = true
                    card.animatedDismiss(completion: completion)
                }
                let rootView = buildContent(dismissAction)
                let host = UIHostingController(rootView: rootView)
                host.view.backgroundColor = .clear
                host._disableSafeArea = true

                let card = BottomSheetCardContainerVC(
                    content: host,
                    topCornerRadius: topCornerRadius,
                    backdropOpacity: backdropOpacity
                )
                card.onDismissed = { [weak self] in
                    self?.presentedVC = nil
                    onDismissed()
                }
                presentedVC = card

                Self.present(card: card, attempts: 12)
            } else if let card = presentedVC {
                presentedVC = nil
                isDismissing = true
                card.animatedDismiss()
            } else {
                // Binding has propagated back to `false` and the card is
                // gone — safe to allow future presentations again.
                isDismissing = false
            }
        }

        func dismantle() {
            if let vc = presentedVC {
                presentedVC = nil
                vc.dismiss(animated: false)
            }
            isDismissing = false
        }

        /// SwiftUI can run `updateUIViewController` before the host view
        /// is attached to a window. Scene-based lookup + retry survives
        /// that race so the modal actually appears.
        ///
        /// Additionally retries while the topmost presenter is mid-
        /// dismiss/present — without this, the follow-on invite sheet
        /// could land on a still-dismissing role card and end up nested
        /// inside it (which kept the role card alive behind the invite).
        private static func present(card: BottomSheetCardContainerVC, attempts: Int) {
            DispatchQueue.main.async {
                if let presenter = topmostPresenter(),
                   presenter.view.window != nil,
                   !presenter.isBeingDismissed,
                   !presenter.isBeingPresented,
                   presenter.presentedViewController == nil {
                    presenter.present(card, animated: false)
                } else if attempts > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        present(card: card, attempts: attempts - 1)
                    }
                }
            }
        }

        private static func topmostPresenter() -> UIViewController? {
            let scenes = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
            let scene = scenes.first(where: { $0.activationState == .foregroundActive })
                ?? scenes.first
            guard let scene else { return nil }
            let window = scene.windows.first(where: \.isKeyWindow)
                ?? scene.windows.first
            guard let window else { return nil }
            var top = window.rootViewController
            // Walk past any VC currently being dismissed — its
            // `presentedViewController` link is still set even though it
            // will momentarily be gone, and presenting onto it would
            // anchor the new modal beneath the old one.
            while let presented = top?.presentedViewController,
                  !presented.isBeingDismissed {
                top = presented
            }
            return top
        }
    }
}

private final class _BottomSheetTriggerVC: UIViewController {
    override func loadView() {
        let v = UIView()
        v.isUserInteractionEnabled = false
        v.backgroundColor = .clear
        view = v
    }
}

// MARK: - UIKit card container (port of HomeInviteCircleSheetContainerVC,
// genericized to host any UIViewController content).

final class BottomSheetCardContainerVC: UIViewController {
    private let content: UIViewController
    private let scrim = UIView()
    private let card = UIView()
    private var cardBottomConstraint: NSLayoutConstraint?
    private var measuredCardHeight: CGFloat = 0
    private var isDismissing = false

    let topCornerRadius: CGFloat
    let backdropOpacity: Double
    var onDismissed: (() -> Void)?

    init(content: UIViewController, topCornerRadius: CGFloat, backdropOpacity: Double) {
        self.content = content
        self.topCornerRadius = topCornerRadius
        self.backdropOpacity = backdropOpacity
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        scrim.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(backdropOpacity))
        scrim.alpha = 0
        scrim.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrim)
        scrim.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(scrimTapped))
        )

        card.backgroundColor = .clear
        card.layer.cornerRadius = topCornerRadius
        card.layer.cornerCurve = .continuous
        card.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        card.clipsToBounds = true
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)

        addChild(content)
        content.view.backgroundColor = .clear
        content.view.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(content.view)
        content.didMove(toParent: self)

        let bottom = card.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottom.isActive = false
        cardBottomConstraint = bottom

        NSLayoutConstraint.activate([
            scrim.topAnchor.constraint(equalTo: view.topAnchor),
            scrim.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrim.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrim.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            card.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            content.view.topAnchor.constraint(equalTo: card.topAnchor),
            content.view.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            content.view.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            content.view.bottomAnchor.constraint(equalTo: card.bottomAnchor),
        ])

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        // Don't steal touches from SwiftUI buttons inside the card — let
        // taps reach them, and only intercept once a real drag starts.
        pan.cancelsTouchesInView = false
        card.addGestureRecognizer(pan)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsLayout()
        view.layoutIfNeeded()

        let targetWidth = view.bounds.width
        let fitting = content.view.systemLayoutSizeFitting(
            CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        let maxHeight = view.bounds.height * 0.95
        measuredCardHeight = min(max(fitting.height, 1), maxHeight)

        cardBottomConstraint?.constant = measuredCardHeight
        cardBottomConstraint?.isActive = true
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardBottomConstraint?.constant = 0
        UIView.animate(
            withDuration: 0.32,
            delay: 0,
            usingSpringWithDamping: 0.92,
            initialSpringVelocity: 0.6,
            options: [.curveEaseOut]
        ) {
            self.scrim.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    @objc private func scrimTapped() { animatedDismiss() }

    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        let translation = g.translation(in: view).y
        switch g.state {
        case .changed:
            if translation > 0 {
                cardBottomConstraint?.constant = translation
                view.layoutIfNeeded()
            }
        case .ended, .cancelled:
            let velocity = g.velocity(in: view).y
            if translation > measuredCardHeight * 0.3 || velocity > 800 {
                animatedDismiss()
            } else {
                cardBottomConstraint?.constant = 0
                UIView.animate(withDuration: 0.22) { self.view.layoutIfNeeded() }
            }
        default:
            break
        }
    }

    func animatedDismiss(completion: @escaping () -> Void = {}) {
        // Guard against double-dismiss (e.g. drag-end + button tap landing
        // in the same runloop). Without it, two parallel UIView.animate
        // calls fight over the constraint and the card visibly bounces.
        guard !isDismissing else {
            completion()
            return
        }
        isDismissing = true

        cardBottomConstraint?.constant = measuredCardHeight
        UIView.animate(
            withDuration: 0.24,
            delay: 0,
            options: [.curveEaseIn],
            animations: {
                self.scrim.alpha = 0
                self.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                guard let self else {
                    completion()
                    return
                }
                self.dismiss(animated: false) {
                    self.onDismissed?()
                    completion()
                }
            }
        )
    }
}

// MARK: - UIHostingController safe-area override
// Allows the hosted SwiftUI content's `ignoresSafeArea` declarations to
// extend past the device safe area inside the card.

private extension UIHostingController {
    var _disableSafeArea: Bool {
        get { false }
        set {
            guard let viewClass = object_getClass(view) else { return }
            let viewSubclassName = String(cString: class_getName(viewClass)).appending("_DisableSafeArea")
            if let subclass = NSClassFromString(viewSubclassName) {
                object_setClass(view, subclass)
            } else {
                guard let nameUtf8 = (viewSubclassName as NSString).utf8String,
                      let subclass = objc_allocateClassPair(viewClass, nameUtf8, 0) else { return }

                if let safeAreaMethod = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
                    let safeAreaImpl: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in .zero }
                    class_addMethod(
                        subclass,
                        #selector(getter: UIView.safeAreaInsets),
                        imp_implementationWithBlock(safeAreaImpl),
                        method_getTypeEncoding(safeAreaMethod)
                    )
                }
                objc_registerClassPair(subclass)
                object_setClass(view, subclass)
            }
        }
    }
}
