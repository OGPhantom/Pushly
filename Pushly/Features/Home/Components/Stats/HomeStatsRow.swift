//
//  HomeStatsRow.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HomeStatsRow: View {
    let thisWeekReps: Int
    let sessionsCount: Int
    let streak: Int

    var body: some View {
        HStack(spacing: 12) {
            HomeStatCard(title: "This Week", value: "\(thisWeekReps)", icon: "flame.fill", color: .orange)
            HomeStatCard(title: "Sessions", value: "\(sessionsCount)", icon: "figure.strengthtraining.traditional", color: .blue)
            HomeStatCard(title: "Streak", value: "\(streak)d", icon: "bolt.fill", color: .yellow)
        }
    }
}

#Preview {
    HomeStatsRow(thisWeekReps: 10, sessionsCount: 44, streak: 7)
}
