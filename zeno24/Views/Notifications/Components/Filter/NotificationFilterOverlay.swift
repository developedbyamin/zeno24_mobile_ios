import SwiftUI

/// Full-screen filter overlay surfaced by the Notifications FAB (Figma
/// 5421:8435). Mirrors `CirclePickerOverlay`'s presentation model: the same
/// lavender 8pt backdrop blur, an internal fade/scale animation driven by
/// `didAppear`, and a black close (×) button below the filter stack.
///
/// Layout matches Figma 1:1 — five right-aligned capsule knobs stacked with a
/// 12pt gap, each with a label on the left and a colored 48pt icon circle on
/// the right, then a 24pt gap before the close button.
struct NotificationFilterOverlay: View {
    let onSelect: (NotificationFilterOption) -> Void
    let onClose: () -> Void

    @State private var didAppear = false

    var body: some View {
        ZStack {
            LavenderBlurBackdrop()
                .opacity(didAppear ? 1 : 0)
                .onTapGesture { dismiss() }

            VStack {
                Spacer(minLength: 0)
                stack
                    .padding(.trailing, 16)
                    .padding(.bottom, 14)
                    .scaleEffect(didAppear ? 1 : 0.94, anchor: .bottomTrailing)
                    .opacity(didAppear ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.22)) {
                didAppear = true
            }
        }
    }

    private var stack: some View {
        VStack(alignment: .trailing, spacing: 24) {
            VStack(alignment: .trailing, spacing: 12) {
                ForEach(NotificationFilterOption.allCases) { option in
                    knob(for: option)
                }
            }
            closeButton
        }
    }

    private func knob(for option: NotificationFilterOption) -> some View {
        HStack(spacing: 8) {
            Text(option.title)
                .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                .foregroundStyle(AppColors.mainBlack)
                .lineLimit(1)
                .padding(.leading, 12)

            ZStack {
                Circle().fill(option.iconBackground)
                Image(option.iconAsset)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
            }
            .frame(width: 48, height: 48)
        }
        .background(Color(hex: 0xF2F5F9), in: Capsule())
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1),
                radius: 8, x: 0, y: 16)
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.05),
                radius: 2, x: 0, y: 4)
        .contentShape(Capsule())
        .onTapGesture {
            onSelect(option)
            dismiss()
        }
    }

    private var closeButton: some View {
        ZStack {
            Circle().fill(Color(hex: 0xF2F5F9))
            Circle()
                .fill(Color(hex: 0x121212))
                .padding(2)
            Image(AppVectors.closeSmall)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)
        }
        .frame(width: 48, height: 48)
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1),
                radius: 8, x: 0, y: 16)
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.05),
                radius: 2, x: 0, y: 4)
        .contentShape(Circle())
        .onTapGesture { dismiss() }
    }

    private func dismiss() {
        withAnimation(.easeIn(duration: 0.18)) {
            didAppear = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            onClose()
        }
    }
}

enum NotificationFilterOption: String, CaseIterable, Identifiable {
    case placeAlerts
    case safeDrive
    case pets
    case offers
    case all

    var id: String { rawValue }

    var title: String {
        switch self {
        case .placeAlerts: AppStrings.Notifications.filterPlaceAlerts
        case .safeDrive:   AppStrings.Notifications.filterSafeDrive
        case .pets:        AppStrings.Notifications.filterPets
        case .offers:      AppStrings.Notifications.filterOffers
        case .all:         AppStrings.Notifications.filterAll
        }
    }

    var iconBackground: Color {
        switch self {
        case .placeAlerts: Color(hex: 0x3DC562)
        case .safeDrive:   Color(hex: 0x0088FF)
        case .pets:        Color(hex: 0x9171F4)
        case .offers:      Color(hex: 0xFF20B5)
        case .all:         Color(hex: 0xFF5F03)
        }
    }

    var iconAsset: String {
        switch self {
        case .placeAlerts: AppVectors.earth
        case .safeDrive:   AppVectors.car
        case .pets:        AppVectors.pets
        case .offers:      AppVectors.diamondStar
        case .all:         AppVectors.circleGridInterface
        }
    }
}
