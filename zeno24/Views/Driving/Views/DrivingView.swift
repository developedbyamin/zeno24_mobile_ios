import SwiftUI

/// Driving safety mode — mirrors driving views
struct DrivingView: View {
    var body: some View {
        VStack(spacing: AppSpacing.l) {
            Text(AppStrings.Driving.title).font(AppTypography.heading2XlBold)
            // TODO: speed gauge, trip history
            Spacer()
        }
        .padding(AppSpacing.l)
        .navigationTitle(AppStrings.Driving.title)
    }
}
