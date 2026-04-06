//
//  HomeGoalProgressCard.swift
//  Pushly
//
//  Created by Никита Сторчай on 05.04.2026.
//

import SwiftUI

struct HomeGoalProgressCard: View {
    let snapshot: DailyGoalSnapshot
    let onOpenSettings: () -> Void

    var body: some View {
        Button {
            onOpenSettings()
        } label: {
            VStack(alignment: .leading, spacing: 18) {
                title

                HStack(spacing: 28) {
                    progressRing
                    progressDetails
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .modifier(CardBackgroundModifier())
        }
        .buttonStyle(.plain)
    }
}

private extension HomeGoalProgressCard {
    var title: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("DAILY GOAL")
                    .font(.caption.weight(.bold))
                    .tracking(2.2)
                    .foregroundStyle(.white.opacity(0.54))

                Text(snapshot.isCompleted ? "Goal complete" : "Keep pushing today")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
    }

    var progressRing: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.08), lineWidth: 12)

            Circle()
                .trim(from: 0, to: snapshot.progress)
                .stroke(
                    LinearGradient(
                        colors: [.orange, .accent, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("\(Int(snapshot.progress * 100))%")
                    .font(.headline.weight(.black))
                    .foregroundStyle(.white)

                Text("done")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.56))
            }
        }
        .frame(width: 92, height: 92)
    }

    var progressDetails: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(snapshot.completedReps) / \(snapshot.goal) reps")
                .font(.title3.weight(.black))
                .foregroundStyle(.white)

            Text(snapshot.isCompleted ? "You hit your target for today." : "\(snapshot.remainingReps) reps left to close the ring.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
    }
}

#Preview {
    HomeGoalProgressCard(snapshot: DailyGoalSnapshot(goal: 50, completedReps: 28)) {
        //
    }
}
