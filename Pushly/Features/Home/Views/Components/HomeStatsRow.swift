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
                statCard(
                    title: "This Week",
                    value: "\(thisWeekReps)",
                    icon: "flame.fill",
                    accent: .orange
                )

                statCard(
                    title: "Sessions",
                    value: "\(sessionsCount)",
                    icon: "figure.strengthtraining.traditional",
                    accent: .blue
                )

                statCard(
                    title: "Streak",
                    value: "\(streak)d",
                    icon: "bolt.fill",
                    accent: .yellow
                )
            }
    }
}

private extension HomeStatsRow {
    func statCard(title: String, value: String, icon: String, accent: Color) -> some View {
        VStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(accent.opacity(0.22))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .center, spacing: 6) {
                Text(value)
                    .font(.title3.weight(.black))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.78))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 54, alignment: .center)
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    accent.opacity(0.28),
                    Color.white.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 26, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    HomeStatsRow(thisWeekReps: 10, sessionsCount: 44, streak: 7)
}
