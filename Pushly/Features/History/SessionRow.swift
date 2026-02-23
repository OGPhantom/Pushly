//
//  SessionRow.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SessionRow: View {
    let session: WorkoutSession

    private var performanceLevel: Double {
        min(max(session.formScore, 0), 1)
    }

    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(Color("AccentColor").opacity(0.8))
                .frame(width: 3)
                .cornerRadius(2)

            VStack(alignment: .leading, spacing: 6) {

                HStack(alignment: .firstTextBaseline) {
                    Text("\(session.totalReps)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))

                    Text("push ups")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(formatSessionRelativeDate(session.date))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(formatDuration(session.duration))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 12)
        .background(
            Color.clear
        )
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
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
}
