//
//  HistorySummaryRow.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI
import Charts

struct HistorySummaryRow: View {
    let sessions: [WorkoutSession]
    let periodTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(periodTitle.uppercased())
                        .font(.caption.weight(.bold))
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.56))

                    Text("\(totalReps)")
                        .font(.system(size: 58, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text(totalReps == 1 ? "push up tracked" : "push ups tracked")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.72))
                }

                Spacer(minLength: 18)

                VStack(alignment: .trailing, spacing: 8) {
                    Text("Technique")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.56))

                    Text("\(Int(avgFormScore * 100))%")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)

                    Text(qualityLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(qualityColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(qualityColor.opacity(0.18), in: Capsule())
                }
            }

            if sessions.isEmpty {
                emptyChartState
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Recent pulse")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)

                        Spacer()

                        Text("Last \(chartSessions.count) sessions")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.54))
                    }

                    Chart(chartSessions) { session in
                        AreaMark(
                            x: .value("Date", session.date),
                            y: .value("Reps", session.totalReps)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.accent.opacity(0.45), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                        LineMark(
                            x: .value("Date", session.date),
                            y: .value("Reps", session.totalReps)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.orange, Color.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))

                        PointMark(
                            x: .value("Date", session.date),
                            y: .value("Reps", session.totalReps)
                        )
                        .foregroundStyle(.white)
                    }
                    .chartXAxis {
                        AxisMarks(values: chartSessions.map(\.date)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                .foregroundStyle(.white.opacity(0.08))
                            AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                                .foregroundStyle(.white.opacity(0.48))
                        }
                    }
                    .chartYAxis(.hidden)
                    .chartLegend(.hidden)
                    .frame(height: 168)

                    HStack(spacing: 10) {
                        metricPill(value: "\(sessions.count)", title: "Sessions")
                        metricPill(value: "\(averageReps)", title: "Avg / Session")
                        metricPill(value: "\(peakReps)", title: "Peak")
                    }
                }
            }
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.10),
                    Color.white.opacity(0.04)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

private extension HistorySummaryRow {
    var totalReps: Int {
        sessions.reduce(0) { $0 + $1.totalReps }
    }

    var avgFormScore: Double {
        guard !sessions.isEmpty else { return 0 }
        return sessions.reduce(0) { $0 + $1.formScore } / Double(sessions.count)
    }

    var averageReps: Int {
        guard !sessions.isEmpty else { return 0 }
        return totalReps / sessions.count
    }

    var peakReps: Int {
        sessions.map(\.totalReps).max() ?? 0
    }

    var chartSessions: [WorkoutSession] {
        Array(sessions.sorted(by: { $0.date < $1.date }).suffix(7))
    }

    var qualityLabel: String {
        switch avgFormScore {
        case 0.9...: return "Locked In"
        case 0.78..<0.9: return "Strong"
        case 0.62..<0.78: return "Steady"
        default: return "Building"
        }
    }

    var qualityColor: Color {
        switch avgFormScore {
        case 0.9...: return .green
        case 0.78..<0.9: return .mint
        case 0.62..<0.78: return .orange
        default: return .yellow
        }
    }

    var emptyChartState: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("No sessions in this range yet.")
                .font(.headline)
                .foregroundStyle(.white)

            Text("Generate mock data or log a workout to unlock your volume trend and summary metrics.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.64))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    func metricPill(value: String, title: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)

            Text(title)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.white.opacity(0.58))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    HistorySummaryRow(sessions: [WorkoutSession(totalReps: 10, duration: 10)], periodTitle: "This Week")
}
