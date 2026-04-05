//
//  GoalsCalendarViewModel.swift
//  Pushly
//
//  Created by Никита Сторчай on 05.04.2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class GoalsCalendarViewModel {
    var displayedMonth: Date
    var showGoalSettings = false

    private let calendar: Calendar
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    init(calendar: Calendar = .current, now: Date = .now) {
        self.calendar = calendar
        displayedMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: now)
        ) ?? now
    }

    var gridColumns: [GridItem] {
        columns
    }

    var monthTitle: String {
        displayedMonth.formatted(.dateTime.month(.wide).year())
    }

    var orderedWeekdaySymbols: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let startIndex = max(calendar.firstWeekday - 1, 0)
        return Array(symbols[startIndex...] + symbols[..<startIndex])
    }

    func todaySnapshot(goal: Int, sessions: [WorkoutSession]) -> DailyGoalSnapshot {
        DailyGoalCalculator.snapshot(goal: goal, sessions: sessions, calendar: calendar)
    }

    func achievedDates(goal: Int, sessions: [WorkoutSession]) -> Set<Date> {
        DailyGoalCalculator.achievedDates(goal: goal, from: sessions, calendar: calendar)
    }

    func monthGridItems() -> [Date?] {
        DailyGoalCalculator.monthGrid(for: displayedMonth, calendar: calendar)
    }

    func achievedThisMonth(goal: Int, sessions: [WorkoutSession]) -> Int {
        DailyGoalCalculator.achievedCount(
            in: displayedMonth,
            goal: goal,
            from: sessions,
            calendar: calendar
        )
    }

    func currentStreak(goal: Int, sessions: [WorkoutSession]) -> Int {
        DailyGoalCalculator.currentGoalStreak(goal: goal, from: sessions, calendar: calendar)
    }

    func previousMonth() {
        guard let previous = calendar.date(byAdding: .month, value: -1, to: displayedMonth) else {
            return
        }

        displayedMonth = previous
    }

    func nextMonth() {
        guard let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) else {
            return
        }

        displayedMonth = next
    }

    func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func dayNumber(for date: Date) -> Int {
        calendar.component(.day, from: date)
    }
}
