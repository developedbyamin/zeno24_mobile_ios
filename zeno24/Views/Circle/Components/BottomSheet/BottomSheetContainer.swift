import SwiftUI
import UIKit

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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}

// MARK: - Dismiss action

struct BottomSheetDismissAction {
    private let action: (@escaping () -> Void) -> Void
    init(_ action: @escaping (@escaping () -> Void) -> Void) { self.action = action }

    func callAsFunction() { action({}) }

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
                if isPresented { isPresented = false }
            }
        )
    }

    static func dismantleUIViewController(_ uiViewController: _BottomSheetTriggerVC,
                                          coordinator: Coordinator) {
        coordinator.dismantle()
    }

    final class Coordinator {
        private var presentedVC: BottomSheetCardContainerVC?
        private var isDismissing = false
        private var hasConsumedPresentation = false

        func sync(
            isPresented: Bool,
            topCornerRadius: CGFloat,
            backdropOpacity: Double,
            buildContent: (BottomSheetDismissAction) -> AnyView,
            onDismissed: @escaping () -> Void
        ) {
            if isPresented {
                if presentedVC != nil || isDismissing || hasConsumedPresentation { return }

                let dismissAction = BottomSheetDismissAction { [weak self] completion in
                    guard let self, let card = self.presentedVC else {
                        completion()
                        return
                    }
                    self.isDismissing = true
                    self.hasConsumedPresentation = true
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
                    self?.hasConsumedPresentation = true
                    onDismissed()
                }
                presentedVC = card

                Self.present(card: card, attempts: 12)
            } else if let card = presentedVC {
                presentedVC = nil
                isDismissing = true
                card.animatedDismiss()
            } else {
                isDismissing = false
                hasConsumedPresentation = false
            }
        }

        func dismantle() {
            if let vc = presentedVC {
                presentedVC = nil
                vc.dismiss(animated: false)
            }
            isDismissing = false
        }

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

// MARK: - UIKit card container

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
