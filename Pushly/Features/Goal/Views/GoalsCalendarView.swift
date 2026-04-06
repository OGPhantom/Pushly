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
                    AppBackgroundView()

                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            GoalSummaryCardView(dailyGoal: dailyGoal,
                                achievedThisMonth: achievedThisMonth,
                                currentStreak: currentStreak
                            )

                            CalendarSectionView(
                                monthTitle: viewModel.monthTitle,
                                weekdaySymbols: viewModel.orderedWeekdaySymbols,
                                gridItems: monthGridItems,
                                achievedDates: achievedDates,
                                columns: viewModel.gridColumns,
                                contentWidth: contentWidth,
                                onPrevious: viewModel.previousMonth,
                                onNext: viewModel.nextMonth,
                                viewModel: viewModel
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

#Preview {
    GoalsCalendarView()
}
