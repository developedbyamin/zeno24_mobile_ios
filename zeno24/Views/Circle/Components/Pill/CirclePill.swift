import SwiftUI

struct CirclePill: View {
    enum Variant { case dark, glass }

    var variant: Variant = .dark
    let fallbackTitle: String
    var onCircleChange: (_ circleId: String) -> Void = { _ in }
    var onTap: (() -> Void)? = nil

    @Environment(CirclesStore.self) private var circles
    @State private var isPickerOpen = false

    private var title: String {
        circles.selectedCircle?.name ?? fallbackTitle
    }

    var body: some View {
        Button {
            if let onTap {
                onTap()
            } else {
                openPickerWithoutSystemTransition()
            }
        } label: {
            label
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $isPickerOpen) {
            CirclePillPickerOverlay(
                circles: circles.circles,
                selectedId: circles.selectedCircleId,
                onSelect: { id in
                    onCircleChange(id)
                },
                onClose: dismissPicker
            )
            .presentationBackground(.clear)
        }
        .transaction(value: isPickerOpen) { txn in
            txn.disablesAnimations = true
        }
    }

    private func openPickerWithoutSystemTransition() {
        var txn = Transaction()
        txn.disablesAnimations = true
        withTransaction(txn) { isPickerOpen = true }
    }

    private func dismissPicker() {
        var txn = Transaction()
        txn.disablesAnimations = true
        withTransaction(txn) { isPickerOpen = false }
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
        .background(AppColors.mainBlack, in: Capsule())
        .shadow(color: AppColors.mainBlack.opacity(0.1), radius: 16, x: 0, y: 16)
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
