import SwiftUI

/// Family health pulse — mirrors health views
struct HealthView: View {
    var body: some View {
        VStack(spacing: AppSpacing.l) {
            Text(AppStrings.Health.title).font(AppTypography.heading2XlBold)
            // TODO: heart rate / step / device cards
            Spacer()
        }
        .padding(AppSpacing.l)
        .navigationTitle(AppStrings.Health.title)
    }
}
