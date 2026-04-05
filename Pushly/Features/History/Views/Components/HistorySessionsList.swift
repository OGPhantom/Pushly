//
//  HistorySessionsList.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HistorySessionsList: View {
    let sessionsSectionTitle: String
    let sessions: [WorkoutSession]
    @Binding var selectedSession: WorkoutSession?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(sessionsSectionTitle.uppercased())
                        .font(.caption.weight(.bold))
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.5))

                    Text("Detailed sessions")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                }

                Spacer()

                Text("\(sessions.count)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.08), in: Capsule())
            }

            if sessions.isEmpty {
                emptyState
            } else {
                listOfSessions
            }
        }
    }
}

private extension HistorySessionsList {
    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.62))
            Text("Nothing logged here yet")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Switch the range or create a few mock sessions to preview the redesigned history flow.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.62))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 34)
        .padding(.horizontal, 22)
        .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    private var listOfSessions: some View {
        LazyVStack(spacing: 14) {
            ForEach(sessions) { session in
                Button {
                    selectedSession = session
                } label: {
                    HistorySessionRow(session: session)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    HistorySessionsList(sessionsSectionTitle: "Week", sessions: [WorkoutSession(totalReps: 10, duration: 10)], selectedSession: .constant(WorkoutSession(totalReps: 10, duration: 10)))
}
