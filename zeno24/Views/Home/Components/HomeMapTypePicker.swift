import SwiftUI

enum HomeMapType: String, CaseIterable, Identifiable {
    case auto, street, satellite
    var id: String { rawValue }

    var label: String {
        switch self {
        case .auto:      return "Auto"
        case .street:    return "Street"
        case .satellite: return "Satellite"
        }
    }

    var imageName: String {
        switch self {
        case .auto, .satellite: return "auto_satellite_map"
        case .street:           return "street_map"
        }
    }
}

struct HomeMapTypePicker: View {
    @Binding var isPresented: Bool
    @Binding var selected: HomeMapType

    @State private var vm = HomeMapTypePickerViewModel()

    private let sheetCorner: CGFloat = 32
    private let tilePadding: CGFloat = 40

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: 0x121212)
                .opacity(vm.visible ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture { vm.dismiss { isPresented = false } }

            VStack(spacing: 0) {
                ZStack {
                    Text("Select Map Type")
                        .font(AppTypography.bodyMdSemiBold)
                        .foregroundStyle(AppColors.mainBlack)
                        .frame(maxWidth: .infinity)

                    HStack {
                        Spacer()
                        Button { vm.dismiss { isPresented = false } } label: {
                            Image(AppVectors.closeSmall)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(AppColors.mainBlack)
                                .frame(width: 32, height: 32)
                                .background(Color(hex: 0xF2F5F9), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 16)
                    }
                }
                .frame(height: 56)
                .background(Color.white)

                Rectangle()
                    .fill(Color(hex: 0xF2F5F9))
                    .frame(height: 1)

                HStack(spacing: 12) {
                    ForEach(HomeMapType.allCases) { type in
                        MapTypeTile(type: type, isSelected: selected == type) {
                            Haptics.selection()
                            selected = type
                            vm.dismiss { isPresented = false }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, tilePadding)
                .background(Color.white)
            }
            .background(Color.white)
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: .init(topLeading: sheetCorner, topTrailing: sheetCorner)
                )
            )
            .offset(y: vm.visible ? max(0, vm.dragOffset) : 600)
            .gesture(
                DragGesture()
                    .onChanged { v in vm.onDragChanged(v.translation.height) }
                    .onEnded { v in
                        vm.onDragEnded(predictedEnd: v.predictedEndTranslation.height) {
                            vm.dismiss { isPresented = false }
                        }
                    }
            )
            .animation(.spring(response: 0.32, dampingFraction: 0.92), value: vm.visible)
            .animation(.interactiveSpring(), value: vm.dragOffset)
        }
        .onAppear { vm.appear() }
    }
}

// MARK: - Tile

private struct MapTypeTile: View {
    let type: HomeMapType
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(type.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(
                                isSelected ? AppColors.brand : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .background(Color(hex: 0xF8F7FF), in: RoundedRectangle(cornerRadius: 24, style: .continuous))

                Text(type.label)
                    .font(AppTypography.bodySmSemiBold)
                    .foregroundStyle(isSelected ? AppColors.brand : AppColors.mainBlack)
            }
        }
        .buttonStyle(.plain)
    }
}
