//
//  DailyGoalCalculator.swift
//  Pushly
//
//  Created by Никита Сторчай on 05.04.2026.
//

import Foundation

enum DailyGoalStorage {
    static let key = "pushly.dailyGoalReps"
    static let defaultReps = 50
}

struct DailyGoalSnapshot {
    let goal: Int
    let completedReps: Int

    var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(completedReps) / Double(goal), 1)
    }

    var remainingReps: Int {
        max(goal - completedReps, 0)
    }

    var isCompleted: Bool {
        completedReps >= goal
    }
}

enum DailyGoalCalculator {
    static func reps(on date: Date, from sessions: [WorkoutSession], calendar: Calendar = .current) -> Int {
        let start = calendar.startOfDay(for: date)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else {
            return 0
        }

        return sessions
            .filter { $0.date >= start && $0.date < end }
            .reduce(0) { $0 + $1.totalReps }
    }

    static func snapshot(
        for date: Date = .now,
        goal: Int,
        sessions: [WorkoutSession],
        calendar: Calendar = .current
    ) -> DailyGoalSnapshot {
        DailyGoalSnapshot(
            goal: goal,
            completedReps: reps(on: date, from: sessions, calendar: calendar)
        )
    }

    static func achievedDates(goal: Int, from sessions: [WorkoutSession], calendar: Calendar = .current) -> Set<Date> {
        guard goal > 0 else { return [] }

        var repsByDay: [Date: Int] = [:]

        for session in sessions {
            let day = calendar.startOfDay(for: session.date)
            repsByDay[day, default: 0] += session.totalReps
        }

        return Set(repsByDay.compactMap { day, reps in
            reps >= goal ? day : nil
        })
    }

    static func achievedCount(in month: Date, goal: Int, from sessions: [WorkoutSession], calendar: Calendar = .current) -> Int {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return 0
        }

        return achievedDates(goal: goal, from: sessions, calendar: calendar)
            .filter { monthInterval.contains($0) }
            .count
    }

    static func currentGoalStreak(goal: Int, from sessions: [WorkoutSession], calendar: Calendar = .current) -> Int {
        let achieved = achievedDates(goal: goal, from: sessions, calendar: calendar)
        guard !achieved.isEmpty else { return 0 }

        var currentDate = calendar.startOfDay(for: .now)
        if !achieved.contains(currentDate) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                return 0
            }
            currentDate = yesterday
        }

        var streak = 0
        while achieved.contains(currentDate) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previous
        }

        return streak
    }

    static func monthGrid(for month: Date, calendar: Calendar = .current) -> [Date?] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let dayRange = calendar.range(of: .day, in: .month, for: month)
        else {
            return []
        }

        let firstDay = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let offset = (firstWeekday - calendar.firstWeekday + 7) % 7

        var grid = Array<Date?>(repeating: nil, count: offset)
        for day in dayRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                grid.append(date)
            }
        }

        while grid.count % 7 != 0 {
            grid.append(nil)
        }

        return grid
    }
}
