import SwiftUI

/// Unified circle pill — the only entry point for switching circles across
/// the entire app. Tapping it surfaces a native iOS context menu anchored
/// to the pill: one row per circle (with a checkmark on the active one),
/// then a divider, then "Create a circle" and "Join a circle" actions.
///
/// Two visual variants:
///   • `.dark`  — 224×46 dark capsule with chevron-up button. Used on
///                Driving, Health, Messages, Notifications (over light
///                backgrounds, lives near the bottom above the tab bar).
///   • `.glass` — translucent material capsule used on the Home map's top
///                bar (sits over the moving map, needs to read through).
///
/// In both cases the title falls back to `fallbackTitle` when no circle is
/// selected.
struct CirclePill: View {
    enum Variant { case dark, glass }

    var variant: Variant = .dark
    let fallbackTitle: String
    /// Called when the user selects a different circle from the built-in
    /// menu. Default no-op.
    var onCircleChange: (_ circleId: String) -> Void = { _ in }
    /// Optional override for the tap action. When provided the pill behaves
    /// as a plain button and fires this closure instead of opening the
    /// built-in `Menu` — used by the Home top bar, which opens its own full
    /// circle picker overlay rather than a context menu.
    var onTap: (() -> Void)? = nil

    @Environment(CirclesStore.self) private var circles
    @Environment(\.openCreateCircle) private var openCreate
    @Environment(\.openJoinCircle) private var openJoin

    private var title: String {
        circles.selectedCircle?.name ?? fallbackTitle
    }

    var body: some View {
        if let onTap {
            Button(action: onTap) { label }
                .buttonStyle(.plain)
        } else {
            Menu {
                menuContent
            } label: {
                label
            }
            .menuStyle(.button)
        }
    }

    @ViewBuilder
    private var menuContent: some View {
        Section {
            ForEach(circles.circles) { circle in
                Button {
                    let id = circle.id
                    Task { await circles.switchTo(id) }
                    onCircleChange(id)
                } label: {
                    if circle.id == circles.selectedCircleId {
                        // SwiftUI renders a leading checkmark automatically
                        // when a Menu Button uses `Label` with the
                        // "checkmark" system image as part of the title.
                        Label(circle.name, systemImage: "checkmark")
                    } else {
                        Text(circle.name)
                    }
                }
            }
        }

        Section {
            Button {
                openCreate()
            } label: {
                Label("Create a circle", systemImage: "plus.circle")
            }
            Button {
                openJoin()
            } label: {
                Label("Join a circle", systemImage: "person.badge.plus")
            }
        }
    }

    @ViewBuilder
    private var label: some View {
        switch variant {
        case .dark:  darkPill
        case .glass: glassPill
        }
    }

    // MARK: - Dark variant

    private var darkPill: some View {
        HStack(spacing: 4) {
            HStack(spacing: 8) {
                Image(AppVectors.circleGridInterface)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                Text(CirclePillTitle.attributed(title, textColor: .white))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.16), in: Capsule())

            Image(systemName: "chevron.up")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(Color.white.opacity(0.24), in: Circle())
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .frame(width: 224)
        .background(Color(hex: 0x121212), in: Capsule())
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 16, x: 0, y: 16)
    }

    // MARK: - Glass variant

    private var glassPill: some View {
        ZStack {
            HomeGlassBackground(shape: Capsule())

            HStack(spacing: 8) {
                Image(AppVectors.circleGridInterface)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(AppColors.brand)

                Text(title)
                    .font(.custom("PlusJakartaSans-Bold", size: 13))
                    .foregroundStyle(AppColors.secondaryBlack)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, 14)

            Image(AppVectors.arrowDown)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(AppColors.mainBlack)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 12)
                .allowsHitTesting(false)
        }
        .frame(height: 40)
    }

    // MARK: - Placement

    /// Pin the pill to the bottom-center the way Figma does.
    ///
    /// Figma reference (4991:18818, 375×812 canvas): pill `y=718`, height 46,
    /// home indicator `y=778`. So the pill sits **14pt above the bottom safe
    /// area** (`778 − (718+46) = 14`). The helper anchors to the parent's
    /// bottom safe area inset and adds 14pt on top — identical in tab-bar
    /// screens, pushed screens, and screens without any chrome.
    ///
    /// Callers can override `gap` (the spacing between the pill and the
    /// bottom safe-area inset) — pass e.g. `0` to hug the inset.
    static func anchored(gap: CGFloat = 14, fallbackTitle: String) -> some View {
        VStack {
            Spacer(minLength: 0)
            CirclePill(fallbackTitle: fallbackTitle)
                .padding(.bottom, gap)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(true)
    }
}
