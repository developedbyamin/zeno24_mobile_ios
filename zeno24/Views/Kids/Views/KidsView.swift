import SwiftUI

/// Kids monitoring — mirrors kids views
struct KidsView: View {
    var body: some View {
        VStack(spacing: AppSpacing.l) {
            Text(AppStrings.Kids.title).font(AppTypography.heading2XlBold)
            // TODO: child profile cards
            Spacer()
        }
        .padding(AppSpacing.l)
        .navigationTitle(AppStrings.Kids.title)
    }
}
