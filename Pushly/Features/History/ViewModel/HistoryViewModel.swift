//
//  HistoryViewModel.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import Foundation

@Observable
final class HistoryViewModel {
    var selectedPeriod: TimePeriod = .day

    func filteredSessions(from sessions: [WorkoutSession]) -> [WorkoutSession] {
        let calendar = Calendar.current
        let now = Date()

        switch selectedPeriod {
        case .day:
            let start = calendar.startOfDay(for: now)
            return sessions.filter { $0.date >= start }

        case .week:
            let start = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            return sessions.filter { $0.date >= start }

        case .month:
            let start = calendar.dateInterval(of: .month, for: now)?.start ?? now
            return sessions.filter { $0.date >= start }

        case .all:
            return sessions
        }
    }

    func totalReps(from sessions: [WorkoutSession]) -> Int {
        filteredSessions(from: sessions).reduce(0) { $0 + $1.totalReps }
    }

    func averageForm(from sessions: [WorkoutSession]) -> Double {
        let filtered = filteredSessions(from: sessions)
        guard !filtered.isEmpty else { return 0 }
        return filtered.reduce(0) { $0 + $1.formScore } / Double(filtered.count)
    }

    var sessionsSectionTitle: String {
        switch selectedPeriod {
        case .day: return "Today"
        case .week: return "This Week"
        case .month: return "This Month"
        case .all: return "All Sessions"
        }
    }

    enum TimePeriod: String, CaseIterable, Sendable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        case all = "All"
    }
}
