//
//  GoalsCalendarView.swift
//  Pushly
//
//  Created by Никита Сторчай on 05.04.2026.
//

import SwiftUI
import SwiftData

struct GoalsCalendarView: View {
    @AppStorage(DailyGoalStorage.key) private var dailyGoal = DailyGoalStorage.defaultReps
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]

    @State private var displayedMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: .now)) ?? .now
    @State private var showGoalSettings = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundLayer

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        summaryCard
                        monthHeader
                        weekdayHeader
                        calendarGrid
                        legend
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showGoalSettings = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.headline)
                    }
                }
            }
            .sheet(isPresented: $showGoalSettings) {
                DailyGoalSettingsView(todayReps: todaySnapshot.completedReps)
            }
        }
    }
}

private extension GoalsCalendarView {
    var calendar: Calendar { .current }

    var todaySnapshot: DailyGoalSnapshot {
        DailyGoalCalculator.snapshot(goal: dailyGoal, sessions: sessions)
    }

    var achievedDates: Set<Date> {
        DailyGoalCalculator.achievedDates(goal: dailyGoal, from: sessions)
    }

    var monthGridItems: [Date?] {
        DailyGoalCalculator.monthGrid(for: displayedMonth)
    }

    var achievedThisMonth: Int {
        DailyGoalCalculator.achievedCount(in: displayedMonth, goal: dailyGoal, from: sessions)
    }

    var currentStreak: Int {
        DailyGoalCalculator.currentGoalStreak(goal: dailyGoal, from: sessions)
    }

    var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.05, blue: 0.09),
                    Color(red: 0.07, green: 0.04, blue: 0.09),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.accent.opacity(0.20))
                .frame(width: 260, height: 260)
                .blur(radius: 55)
                .offset(x: 130, y: -230)
        }
    }

    var summaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("GOAL TRACKER")
                .font(.caption.weight(.bold))
                .tracking(2)
                .foregroundStyle(.white.opacity(0.54))

            Text("\(dailyGoal) reps a day")
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text("Days light up once your total reps for that date reach the goal.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.68))

            HStack(spacing: 10) {
                statPill(title: "This Month", value: "\(achievedThisMonth) days")
                statPill(title: "Current Streak", value: "\(currentStreak)d")
            }
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.10),
                    Color.white.opacity(0.04)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    var monthHeader: some View {
        HStack {
            Button {
                if let previous = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
                    displayedMonth = previous
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.white.opacity(0.08), in: Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(displayedMonth.formatted(.dateTime.month(.wide).year()))
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            Spacer()

            Button {
                if let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
                    displayedMonth = next
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.white.opacity(0.08), in: Circle())
            }
            .buttonStyle(.plain)
        }
    }

    var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(orderedWeekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.48))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Array(monthGridItems.enumerated()), id: \.offset) { _, date in
                if let date {
                    dayCell(for: date)
                } else {
                    Color.clear
                        .frame(height: 54)
                }
            }
        }
    }

    var legend: some View {
        HStack(spacing: 14) {
            legendItem(color: .accent, title: "Goal hit")
            legendItem(color: .white.opacity(0.16), title: "No goal")
            legendItem(color: .clear, title: "Today", border: .white)
        }
        .padding(.top, 4)
    }

    func dayCell(for date: Date) -> some View {
        let day = calendar.startOfDay(for: date)
        let isToday = calendar.isDateInToday(day)
        let didHitGoal = achievedDates.contains(day)

        return VStack(spacing: 6) {
            Text("\(calendar.component(.day, from: day))")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)

            Circle()
                .fill(
                    didHitGoal
                    ? .accent
                    : .white.opacity(0.16)
                )
                .frame(width: 8, height: 8)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(didHitGoal ? .white.opacity(0.12) : .white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(isToday ? .white.opacity(0.84) : .white.opacity(0.06), lineWidth: isToday ? 1.5 : 1)
        )
    }

    func statPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.white.opacity(0.52))

            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.black.opacity(0.16), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    var orderedWeekdaySymbols: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let startIndex = max(calendar.firstWeekday - 1, 0)
        return Array(symbols[startIndex...] + symbols[..<startIndex])
    }

    func legendItem(color: Color, title: String, border: Color? = nil) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .overlay(
                    Circle()
                        .stroke(border ?? .clear, lineWidth: border == nil ? 0 : 1.5)
                )
                .frame(width: 10, height: 10)

            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.62))
        }
    }
}

#Preview {
    GoalsCalendarView()
}
