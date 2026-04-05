//
//  HistoryViewModel.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import Foundation
import SwiftData

@Observable
final class HistoryViewModel {
    var selectedPeriod: TimePeriod = .day

    @discardableResult
    func generateMockSessions(in modelContext: ModelContext) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let dayOffsets = [
            0, 0, 0, 1, 1, 2, 3, 4, 5, 6,
            8, 10, 12, 15, 18, 21, 24, 27,
            32, 36, 41, 47, 54, 61, 70, 82,
            96, 111, 129, 146, 168, 190
        ]

        for (index, dayOffset) in dayOffsets.enumerated() {
            guard
                let baseDate = calendar.date(byAdding: .day, value: -dayOffset, to: now),
                let sessionDate = calendar.date(
                    bySettingHour: 6 + (index * 3) % 13,
                    minute: (index * 11) % 60,
                    second: 0,
                    of: baseDate
                )
            else {
                continue
            }

            let totalReps = 18 + (index * 7) % 55
            let duration = TimeInterval(240 + (index * 37) % 1100)
            let averageTempo = 1.1 + Double((index * 9) % 18) / 10
            let formScore = min(0.62 + Double((index * 5) % 35) / 100, 0.96)
            let calories = Double(totalReps) * 0.45

            let session = WorkoutSession(
                date: sessionDate,
                totalReps: totalReps,
                duration: duration,
                averageTempo: averageTempo,
                formScore: formScore,
                calories: calories
            )

            modelContext.insert(session)
        }

        try? modelContext.save()
        return dayOffsets.count
    }

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

        case .year:
            let start = calendar.dateInterval(of: .year, for: .now)?.start ?? now
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
        case .year:  return "This year"
        case .all: return "All Sessions"
        }
    }

    enum TimePeriod: String, CaseIterable, Sendable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All"
    }
}
