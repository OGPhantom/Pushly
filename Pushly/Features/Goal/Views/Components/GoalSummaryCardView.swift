//
//  GoalSummaryCardView.swift
//  Pushly
//
//  Created by Никита Сторчай on 06.04.2026.
//

import SwiftUI

struct GoalSummaryCardView: View {
    let dailyGoal: Int
    let achievedThisMonth: Int
    let currentStreak: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("GOAL TRACKER")
                .font(.caption.weight(.bold))
                .tracking(2)
                .foregroundStyle(.white.opacity(0.54))

            Text("\(dailyGoal) reps a day")
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            HStack(spacing: 10) {
                StatPillView(
                    title: "This Month",
                    value: "\(achievedThisMonth) days"
                )

                StatPillView(
                    title: "Current Streak",
                    value: "\(currentStreak)d"
                )
            }
        }
        .modifier(CardBackgroundModifier())
    }
}

#Preview {
    GoalSummaryCardView(dailyGoal: 10, achievedThisMonth: 2, currentStreak: 5)
}
