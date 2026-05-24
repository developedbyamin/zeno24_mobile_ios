import SwiftUI

struct SpeedGauge: View {
    let kph: Double
    let max: Double = 200

    var body: some View {
        Gauge(value: kph, in: 0...max) {
            Text("km/h")
        } currentValueLabel: {
            Text("\(Int(kph))")
                .font(AppTypography.headingMdSemiBold)
        }
        .gaugeStyle(.accessoryCircular)
        .tint(AppColors.primary)
    }
}
