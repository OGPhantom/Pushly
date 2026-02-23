//
//  SummaryView.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI

struct SummaryView: View {
    let session: WorkoutSession
    let onDismiss: () -> Void

    private var formColor: Color {
        if session.formScore >= 0.8 { return .green }
        if session.formScore >= 0.5 { return .orange }
        return .red
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 28) {
                    headerSection
                    metricsGrid
                    formSection
                }
                .padding(.horizontal)
                .padding(.top, 40)
                .padding(.bottom, 24)
            }

            doneButton
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)
                .symbolEffect(.bounce, value: true)

            Text("Workout Complete!")
                .font(.title.bold())

            Text(session.date.formatted(date: .abbreviated, time: .shortened))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            MetricCard(
                icon: "flame.fill",
                iconColor: .orange,
                value: "\(session.totalReps)",
                label: "Push Ups"
            )

            MetricCard(
                icon: "timer",
                iconColor: Color("AccentColor"),
                value: formatDurationSummary(session.duration),
                label: "Duration"
            )

            MetricCard(
                icon: "bolt.fill",
                iconColor: .yellow,
                value: session.averageTempo > 0 ? String(format: "%.1fs", session.averageTempo) : "—",
                label: "Avg Tempo"
            )

            MetricCard(
                icon: "flame",
                iconColor: .red,
                value: String(format: "%.0f", session.calories),
                label: "kcal"
            )
        }
    }

    private var formSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Form Quality")
                    .font(.headline)
                Spacer()
                Text("\(Int(session.formScore * 100))%")
                    .font(.title2.bold())
                    .foregroundStyle(formColor)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(formColor)
                        .frame(width: geo.size.width * session.formScore, height: 12)
                }
            }
            .frame(height: 12)

            HStack(spacing: 16) {
                formLegendItem(color: .green, label: "Good")
                formLegendItem(color: .orange, label: "Warning")
                formLegendItem(color: .red, label: "Needs Work")
                Spacer()
            }
            .font(.caption)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 14))
    }

    private func formLegendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(label)
                .foregroundStyle(.secondary)
        }
    }

    private var doneButton: some View {
        Button {
            onDismiss()
        } label: {
            Text("Done")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color("AccentColor"), in: .rect(cornerRadius: 14))
        }
    }

    private func formatDurationSummary(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct MetricCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)

            Text(value)
                .font(.title.bold())

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 14))
    }
}
