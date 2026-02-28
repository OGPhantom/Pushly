//
//  HistorySummaryRow.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HistorySummaryRow: View {
    let totalReps: Int
    let sessionsCount: Int
    let avgFormScore: Double

    var body: some View {
        HStack(spacing: 12) {
            metric(value: "\(totalReps)", title: "Total")

            Divider().frame(height: 40)

            metric(value: "\(sessionsCount)", title: "Sessions")

            Divider().frame(height: 40)

            metric(value: "\(Int(avgFormScore * 100))%", title: "Technique")
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 14))
    }
}

private extension HistorySummaryRow {
    private func metric(value: String, title: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
