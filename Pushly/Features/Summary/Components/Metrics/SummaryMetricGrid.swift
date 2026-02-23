//
//  SummaryMetricGrid.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SummaryMetricGrid: View {
    let totalReps: Int
    let duration: String
    let averageTempo: Double
    let calories: String

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            SummaryMetricCard(
                icon: "flame.fill",
                iconColor: .orange,
                value: "\(totalReps)",
                label: "Push Ups"
            )

            SummaryMetricCard(
                icon: "timer",
                iconColor: .blue,
                value: duration,
                label: "Duration"
            )

            SummaryMetricCard(
                icon: "bolt.fill",
                iconColor: .yellow,
                value: averageTempo > 0 ? String(format: "%.1fs", averageTempo) : "—",
                label: "Avg Tempo"
            )

            SummaryMetricCard(
                icon: "flame",
                iconColor: .red,
                value: calories,
                label: "kcal"
            )
        }
    }
}

#Preview {
    SummaryMetricGrid(totalReps: 10, duration: "0:20", averageTempo: 1.7, calories: "4")
}
