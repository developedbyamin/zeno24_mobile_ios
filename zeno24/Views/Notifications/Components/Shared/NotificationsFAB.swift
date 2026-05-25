import SwiftUI

struct NotificationsFAB: View {
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            Image(AppVectors.circleGridInterface)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color(hex: 0xFF5F03), in: Circle())
                .padding(2)
                .background(Color.white, in: Circle())
                .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 8, x: 0, y: 16)
        }
        .buttonStyle(.plain)
    }
}
