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

    @State private var viewModel = GoalsCalendarViewModel()

    var body: some View {
        let todaySnapshot = viewModel.todaySnapshot(goal: dailyGoal, sessions: sessions)
        let achievedDates = viewModel.achievedDates(goal: dailyGoal, sessions: sessions)
        let monthGridItems = viewModel.monthGridItems()
        let achievedThisMonth = viewModel.achievedThisMonth(goal: dailyGoal, sessions: sessions)
        let currentStreak = viewModel.currentStreak(goal: dailyGoal, sessions: sessions)

        NavigationStack {
            GeometryReader { proxy in
                let contentWidth = max(proxy.size.width - 40, 0)

                ZStack {
                    backgroundLayer

                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            summaryCard(
                                achievedThisMonth: achievedThisMonth,
                                currentStreak: currentStreak
                            )
                            monthHeader
                            weekdayHeader(contentWidth: contentWidth)
                            calendarGrid(
                                monthGridItems: monthGridItems,
                                achievedDates: achievedDates,
                                contentWidth: contentWidth
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 40)
                        .frame(width: proxy.size.width, alignment: .topLeading)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showGoalSettings = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.headline)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showGoalSettings) {
                DailyGoalSettingsView(todayReps: todaySnapshot.completedReps)
            }
        }
    }
}

private extension GoalsCalendarView {
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

    func summaryCard(achievedThisMonth: Int, currentStreak: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("GOAL TRACKER")
                .font(.caption.weight(.bold))
                .tracking(2)
                .foregroundStyle(.white.opacity(0.54))

            Text("\(dailyGoal) reps a day")
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            HStack(spacing: 10) {
                statPill(title: "This Month", value: "\(achievedThisMonth) days")
                statPill(title: "Current Streak", value: "\(currentStreak)d")
            }
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [
                    Color.accent.opacity(0.24),
                    Color.white.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }

    func statPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.white.opacity(0.74))

            Text(value)
                .font(.title3.weight(.black))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.10),
                    Color.white.opacity(0.04)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    var monthHeader: some View {
        HStack {
            Button {
                viewModel.previousMonth()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.white.opacity(0.08), in: Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(viewModel.monthTitle)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            Spacer()

            Button {
                viewModel.nextMonth()
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

    func weekdayHeader(contentWidth: CGFloat) -> some View {
        LazyVGrid(columns: viewModel.gridColumns, spacing: 8) {
            ForEach(Array(viewModel.orderedWeekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.48))
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(width: contentWidth, alignment: .leading)
    }

    func calendarGrid(monthGridItems: [Date?], achievedDates: Set<Date>, contentWidth: CGFloat) -> some View {
        LazyVGrid(columns: viewModel.gridColumns, spacing: 10) {
            ForEach(Array(monthGridItems.enumerated()), id: \.offset) { _, date in
                if let date {
                    dayCell(for: date, achievedDates: achievedDates)
                } else {
                    Color.clear
                        .frame(height: 54)
                }
            }
        }
        .frame(width: contentWidth, alignment: .leading)
    }

    func dayCell(for date: Date, achievedDates: Set<Date>) -> some View {
        let day = viewModel.startOfDay(for: date)
        let isToday = viewModel.isToday(day)
        let didHitGoal = achievedDates.contains(day)

        return VStack(spacing: 6) {
            Text("\(viewModel.dayNumber(for: day))")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)

            Circle()
                .fill(
                    didHitGoal
                    ? .orange
                    : .white.opacity(0.16)
                )
                .frame(width: 8, height: 8)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    didHitGoal
                    ? Color.accent.opacity(0.22)
                    : Color.white.opacity(0.04)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    isToday
                    ? Color.white.opacity(didHitGoal ? 0.75 : 0.35)
                    : didHitGoal
                        ? Color.accent.opacity(0.35)
                        : Color.white.opacity(0.06),
                    lineWidth: isToday ? 1.5 : 1
                )
        )
    }
}

#Preview {
    GoalsCalendarView()
}
