import SwiftUI

struct ChatView: View {
    let circleId: String
    @State private var draft: String = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
            }

            HStack(spacing: AppSpacing.s) {
                TextField(AppStrings.Chat.placeholder, text: $draft)
                    .textFieldStyle(.roundedBorder)
                Button {
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding(AppSpacing.m)
                        .background(AppColors.primary)
                        .clipShape(Circle())
                }
            }
            .padding(AppSpacing.m)
        }
        .navigationTitle(AppStrings.Chat.title)
    }
}
