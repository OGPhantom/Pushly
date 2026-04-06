//
//  HistoryViewModel.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import Foundation
import SwiftData

struct HistoryChartPoint: Identifiable, Hashable {
    let date: Date
    let reps: Int
    let label: String

    var id: Date { date }
}

struct HistoryChartData {
    let points: [HistoryChartPoint]
    let axisDates: [Date]
    let detail: String
}

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

    func chartData(from sessions: [WorkoutSession], now: Date = .now, calendar: Calendar = .current) -> HistoryChartData {
        switch selectedPeriod {
        case .day:
            return hourlyChartData(from: sessions, now: now, calendar: calendar)

        case .week:
            return dailyChartData(from: sessions, now: now, calendar: calendar)

        case .month:
            return weeklyChartData(from: sessions, now: now, calendar: calendar)

        case .year:
            return monthlyChartData(from: sessions, now: now, calendar: calendar)

        case .all:
            return allTimeChartData(from: sessions, calendar: calendar)
        }
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

private extension HistoryViewModel {
    func hourlyChartData(from sessions: [WorkoutSession], now: Date, calendar: Calendar) -> HistoryChartData {
        let dayStart = calendar.startOfDay(for: now)
        let buckets = (0..<24).compactMap { hour -> DateInterval? in
            guard let start = calendar.date(byAdding: .hour, value: hour, to: dayStart),
                  let end = calendar.date(byAdding: .hour, value: 1, to: start) else {
                return nil
            }

            return DateInterval(start: start, end: end)
        }

        let points = buckets.map { interval in
            HistoryChartPoint(
                date: interval.start,
                reps: reps(in: interval, from: sessions),
                label: String(format: "%02d", calendar.component(.hour, from: interval.start))
            )
        }

        let axisDates = points.enumerated().compactMap { index, point in
            index.isMultiple(of: 4) ? point.date : nil
        }

        return HistoryChartData(
            points: points,
            axisDates: axisDates,
            detail: "Hourly volume"
        )
    }

    func dailyChartData(from sessions: [WorkoutSession], now: Date, calendar: Calendar) -> HistoryChartData {
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? calendar.startOfDay(for: now)
        let buckets = (0..<7).compactMap { dayOffset -> DateInterval? in
            guard let start = calendar.date(byAdding: .day, value: dayOffset, to: weekStart),
                  let end = calendar.date(byAdding: .day, value: 1, to: start) else {
                return nil
            }

            return DateInterval(start: start, end: end)
        }

        let points = buckets.map { interval in
            HistoryChartPoint(
                date: interval.start,
                reps: reps(in: interval, from: sessions),
                label: interval.start.formatted(.dateTime.weekday(.abbreviated))
            )
        }

        return HistoryChartData(
            points: points,
            axisDates: reducedAxisDates(from: points, maxVisibleLabels: 7),
            detail: "Daily volume"
        )
    }

    func weeklyChartData(from sessions: [WorkoutSession], now: Date, calendar: Calendar) -> HistoryChartData {
        guard let monthInterval = calendar.dateInterval(of: .month, for: now) else {
            return HistoryChartData(points: [], axisDates: [], detail: "Weekly volume")
        }

        let buckets = chunkedIntervals(
            inside: monthInterval,
            component: .day,
            step: 7,
            calendar: calendar
        )

        let points = buckets.map { interval in
            HistoryChartPoint(
                date: interval.start,
                reps: reps(in: interval, from: sessions),
                label: weekRangeLabel(for: interval, in: monthInterval, calendar: calendar)
            )
        }

        return HistoryChartData(
            points: points,
            axisDates: reducedAxisDates(from: points, maxVisibleLabels: 5),
            detail: "Weekly volume"
        )
    }

    func monthlyChartData(from sessions: [WorkoutSession], now: Date, calendar: Calendar) -> HistoryChartData {
        guard let yearInterval = calendar.dateInterval(of: .year, for: now) else {
            return HistoryChartData(points: [], axisDates: [], detail: "Monthly volume")
        }

        let buckets = chunkedIntervals(
            inside: yearInterval,
            component: .month,
            step: 1,
            calendar: calendar
        )

        let points = buckets.map { interval in
            HistoryChartPoint(
                date: interval.start,
                reps: reps(in: interval, from: sessions),
                label: interval.start.formatted(.dateTime.month(.abbreviated))
            )
        }

        return HistoryChartData(
            points: points,
            axisDates: reducedAxisDates(from: points, maxVisibleLabels: 6),
            detail: "Monthly volume"
        )
    }

    func allTimeChartData(from sessions: [WorkoutSession], calendar: Calendar) -> HistoryChartData {
        guard
            let earliestSession = sessions.min(by: { $0.date < $1.date })?.date,
            let latestSession = sessions.max(by: { $0.date < $1.date })?.date
        else {
            return HistoryChartData(points: [], axisDates: [], detail: "All-time volume")
        }

        let monthSpan = monthDistance(from: earliestSession, to: latestSession, calendar: calendar)

        if monthSpan <= 18 {
            let start = calendar.dateInterval(of: .month, for: earliestSession)?.start ?? earliestSession
            let monthAfterLatest = calendar.date(byAdding: .month, value: 1, to: latestSession) ?? latestSession
            let end = calendar.dateInterval(of: .month, for: monthAfterLatest)?.start ?? monthAfterLatest

            let buckets = chunkedIntervals(
                inside: DateInterval(start: start, end: end),
                component: .month,
                step: 1,
                calendar: calendar
            )

            let points = buckets.map { interval in
                HistoryChartPoint(
                    date: interval.start,
                    reps: reps(in: interval, from: sessions),
                    label: allTimeMonthLabel(for: interval.start, calendar: calendar)
                )
            }

            return HistoryChartData(
                points: points,
                axisDates: reducedAxisDates(from: points, maxVisibleLabels: 5),
                detail: "Monthly all-time volume"
            )
        }

        let yearStart = calendar.dateInterval(of: .year, for: earliestSession)?.start ?? earliestSession
        let nextYear = calendar.date(byAdding: .year, value: 1, to: latestSession) ?? latestSession
        let yearEnd = calendar.dateInterval(of: .year, for: nextYear)?.start ?? nextYear

        let buckets = chunkedIntervals(
            inside: DateInterval(start: yearStart, end: yearEnd),
            component: .year,
            step: 1,
            calendar: calendar
        )

        let points = buckets.map { interval in
            HistoryChartPoint(
                date: interval.start,
                reps: reps(in: interval, from: sessions),
                label: interval.start.formatted(.dateTime.year())
            )
        }

        return HistoryChartData(
            points: points,
            axisDates: reducedAxisDates(from: points, maxVisibleLabels: 6),
            detail: "Yearly all-time volume"
        )
    }

    func reps(in interval: DateInterval, from sessions: [WorkoutSession]) -> Int {
        sessions
            .filter { interval.contains($0.date) }
            .reduce(0) { $0 + $1.totalReps }
    }

    func chunkedIntervals(
        inside interval: DateInterval,
        component: Calendar.Component,
        step: Int,
        calendar: Calendar
    ) -> [DateInterval] {
        var intervals: [DateInterval] = []
        var cursor = interval.start

        while cursor < interval.end {
            guard let next = calendar.date(byAdding: component, value: step, to: cursor) else {
                break
            }

            intervals.append(DateInterval(start: cursor, end: min(next, interval.end)))
            cursor = next
        }

        return intervals
    }

    func weekRangeLabel(for interval: DateInterval, in monthInterval: DateInterval, calendar: Calendar) -> String {
        let startDay = calendar.component(.day, from: interval.start)
        let labelEnd = min(interval.end.addingTimeInterval(-1), monthInterval.end.addingTimeInterval(-1))
        let endDay = calendar.component(.day, from: labelEnd)
        return "\(startDay)-\(endDay)"
    }

    func monthDistance(from start: Date, to end: Date, calendar: Calendar) -> Int {
        let startMonth = calendar.dateInterval(of: .month, for: start)?.start ?? start
        let endMonth = calendar.dateInterval(of: .month, for: end)?.start ?? end
        return calendar.dateComponents([.month], from: startMonth, to: endMonth).month ?? 0
    }

    func reducedAxisDates(from points: [HistoryChartPoint], maxVisibleLabels: Int) -> [Date] {
        guard !points.isEmpty else { return [] }
        guard points.count > maxVisibleLabels else { return points.map(\.date) }

        let stride = Int(ceil(Double(points.count) / Double(maxVisibleLabels)))
        var dates = points.enumerated().compactMap { index, point in
            index.isMultiple(of: stride) ? point.date : nil
        }

        if let last = points.last?.date, dates.last != last {
            dates.append(last)
        }

        return dates
    }

    func allTimeMonthLabel(for date: Date, calendar: Calendar) -> String {
        let month = date.formatted(.dateTime.month(.abbreviated))
        let year = date.formatted(.dateTime.year(.twoDigits))
        return "\(month)\n\(year)"
    }
}
