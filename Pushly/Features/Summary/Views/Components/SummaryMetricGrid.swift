//
//  SummaryMetricGrid.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SummaryMetricGrid: View {
    let session: WorkoutSession

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session Metrics")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                metricCard(
                    title: "Duration",
                    value: session.formattedDuration,
                    note: "Time under load",
                    icon: "timer",
                    colors: [Color.blue.opacity(0.42), Color.cyan.opacity(0.18)]
                )

                metricCard(
                    title: "Avg Tempo",
                    value: session.averageTempo > 0 ? String(format: "%.1fs", session.averageTempo) : "No read",
                    note: "Per repetition",
                    icon: "metronome.fill",
                    colors: [Color.orange.opacity(0.42), Color.red.opacity(0.18)]
                )

                metricCard(
                    title: "Calories",
                    value: "\(session.formattedCalories) kcal",
                    note: "Estimated burn",
                    icon: "flame.fill",
                    colors: [Color.pink.opacity(0.42), Color.purple.opacity(0.16)]
                )

                metricCard(
                    title: "Output",
                    value: outputText,
                    note: "Reps per minute",
                    icon: "waveform.path.ecg",
                    colors: [Color.green.opacity(0.38), Color.mint.opacity(0.16)]
                )
            }
        }
    }
}

private extension SummaryMetricGrid {
    var outputText: String {
        guard session.duration > 0 else { return "0.0" }
        let repsPerMinute = Double(session.totalReps) / max(session.duration / 60, 1)
        return String(format: "%.1f", repsPerMinute)
    }

    func metricCard(title: String, value: String, note: String, icon: String, colors: [Color]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                Circle()
                    .fill(colors[0].opacity(0.24))
                    .frame(width: 42, height: 42)

                Image(systemName: icon)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(value)
                    .font(.title2.weight(.black))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.78))

                Text(note)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.48))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 158, alignment: .topLeading)
        .padding(18)
        .background(
            LinearGradient(
                colors: [
                    colors[0],
                    Color.white.opacity(0.05),
                    colors[1]
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    SummaryMetricGrid(session: WorkoutSession(totalReps: 10, duration: 10))
}
