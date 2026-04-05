//
//  HistorySessionRow.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HistorySessionRow: View {
    let session: WorkoutSession

    private var performanceLevel: Double {
        min(max(session.formScore, 0), 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(session.date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)

                    Text(session.date.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.54))
                }

                Spacer()

                Text("\(Int(performanceLevel * 100))% form")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(formColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(formColor.opacity(0.14), in: Capsule())
            }

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("\(session.totalReps)")
                    .font(.system(size: 46, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text("REPS")
                        .font(.caption.weight(.bold))
                        .tracking(2.2)
                        .foregroundStyle(.white.opacity(0.46))

                    Text(formatSessionRelativeDate(session.date))
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.66))
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.34))
            }

            HStack(spacing: 10) {
                detailPill(icon: "timer", value: session.formattedDuration)
                detailPill(icon: "bolt.fill", value: tempoText)
                detailPill(icon: "flame.fill", value: "\(session.formattedCalories) kcal")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.10),
                    Color.white.opacity(0.04)
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
        .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
    }

    private func formatSessionRelativeDate(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)

        if interval < 60 {
            return "Recently"
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private var formColor: Color {
        switch performanceLevel {
        case 0.9...: return .green
        case 0.75..<0.9: return .mint
        case 0.6..<0.75: return .orange
        default: return .yellow
        }
    }

    private var tempoText: String {
        guard session.averageTempo > 0 else { return "No tempo" }
        return String(format: "%.1fs pace", session.averageTempo)
    }

    private func detailPill(icon: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.72))

            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.76))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.black.opacity(0.16), in: Capsule())
    }
}


#Preview {
    HistorySessionRow(session: WorkoutSession(totalReps: 10, duration: 10))
}
