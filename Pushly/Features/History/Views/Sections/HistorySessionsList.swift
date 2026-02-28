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
        VStack(alignment: .leading, spacing: 12) {
            Text(sessionsSectionTitle)
                .font(.headline)

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
        VStack(spacing: 12) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("No sessions yet")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var listOfSessions: some View {
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
