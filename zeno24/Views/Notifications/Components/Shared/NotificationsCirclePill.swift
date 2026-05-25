import SwiftUI

struct NotificationsCirclePill: View {
    @Environment(\.openCirclePicker) private var openPicker
    @Environment(CirclesStore.self) private var circles
    @Environment(\.circlePillNamespace) private var pillNS
    @Environment(\.circlePickerOpen) private var pickerOpen

    var body: some View {
        if !pickerOpen {
            pill
                .modifier(CirclePillHeroModifier(namespace: pillNS))
        }
    }

    private var pill: some View {
        Button {
            openPicker()
        } label: {
            HStack(spacing: 4) {
                HStack(spacing: 8) {
                    Image(AppVectors.circleGridInterface)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Text(CirclePillTitle.attributed(
                        circles.selectedCircle?.name ?? AppStrings.Notifications.circleName,
                        textColor: .white
                    ))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.16), in: Capsule())

                ZStack {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 38, height: 38)
                .background(Color.white.opacity(0.24), in: Circle())
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .frame(width: 224)
            .background(Color(hex: 0x121212), in: Capsule())
        }
        .buttonStyle(.plain)
        .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 16, x: 0, y: 16)
    }
}
