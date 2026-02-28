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
            StatCard(title: "Push Ups", value: "\(totalReps)", icon: "flame.fill", color: .orange)

            StatCard(title: "Duration", value: duration, icon: "timer", color: .blue)

            StatCard(title: "Avg Tempo", value: averageTempo > 0 ? String(format: "%.1fs", averageTempo) : "—", icon: "bolt.fill", color: .yellow)

            StatCard(title: "kcal", value: calories, icon: "flame", color: .red)
        }
    }
}

#Preview {
    SummaryMetricGrid(totalReps: 10, duration: "0:20", averageTempo: 1.7, calories: "4")
}
