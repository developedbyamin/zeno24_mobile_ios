import SwiftUI

struct HealthMonthlySummaryCard: View {
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let dates = ["10", "11", "12", "13", "14", "15"]
    private let selectedIndex = 4
    private let stepValues: [CGFloat] = [0.3, 0.5, 0.4, 0.45, 0.85, 0.5]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(AppStrings.Health.monthlySummary)
                .font(AppTypography.bodyMdSemiBold)
                .foregroundStyle(AppColors.mainBlack)

            Color(hex: 0xF2F5F9).frame(height: 1)

            VStack(spacing: 4) {
                weekRow
                chartArea
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var weekRow: some View {
        HStack(spacing: 0) {
            ForEach(Array(days.enumerated()), id: \.offset) { idx, day in
                VStack(spacing: 8) {
                    Text(day)
                        .font(AppTypography.bodyXsSemiBold)
                        .foregroundStyle(Color(hex: 0x8B98A8))
                    if idx == selectedIndex {
                        Text(dates[idx])
                            .font(AppTypography.bodySmBold)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(AppColors.brand, in: Circle())
                    } else {
                        Text(dates[idx])
                            .font(AppTypography.bodySmBold)
                            .foregroundStyle(AppColors.mainBlack)
                            .padding(8)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var chartArea: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { proxy in
                let w = proxy.size.width
                let cols = days.count
                let step = w / CGFloat(cols)
                Path { path in
                    for i in 0..<cols {
                        let x = step * CGFloat(i) + step / 2
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: proxy.size.height))
                    }
                }
                .stroke(Color(hex: 0xF2F5F9), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
            }

            GeometryReader { proxy in
                let w = proxy.size.width
                let h = proxy.size.height
                let cols = days.count
                let step = w / CGFloat(cols)
                let points = stepValues.enumerated().map { idx, v in
                    CGPoint(x: step * CGFloat(idx) + step / 2, y: h - (h - 24) * v)
                }

                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: CGPoint(x: first.x, y: h))
                    path.addLine(to: first)
                    for pt in points.dropFirst() {
                        path.addLine(to: pt)
                    }
                    if let last = points.last {
                        path.addLine(to: CGPoint(x: last.x, y: h))
                    }
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [AppColors.brand.opacity(0.35), AppColors.brand.opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)
                    for pt in points.dropFirst() {
                        path.addLine(to: pt)
                    }
                }
                .stroke(AppColors.brand, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                if selectedIndex < points.count {
                    let pt = points[selectedIndex]
                    HStack {
                        Text("4,890")
                            .font(AppTypography.bodySmBold)
                            .foregroundStyle(AppColors.brand)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.white, in: Capsule())
                            .shadow(color: Color(red: 12/255, green: 12/255, blue: 13/255).opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                    .position(x: pt.x, y: pt.y - 20)
                }
            }
        }
        .frame(height: 150)
    }
}
