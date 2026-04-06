//
//  CalendarSectionView.swift
//  Pushly
//
//  Created by Никита Сторчай on 06.04.2026.
//

import SwiftUI

struct CalendarSectionView: View {
    let monthTitle: String
    let weekdaySymbols: [String]
    let gridItems: [Date?]
    let achievedDates: Set<Date>
    let columns: [GridItem]
    let contentWidth: CGFloat
    let onPrevious: () -> Void
    let onNext: () -> Void
    let viewModel: GoalsCalendarViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            monthHeader
            weekdayHeader
            calendarGrid
        }
    }

    private var monthHeader: some View {
        HStack {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.white.opacity(0.08), in: Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(monthTitle)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            Spacer()

            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.white.opacity(0.08), in: Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.48))
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(width: contentWidth, alignment: .leading)
    }

    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Array(gridItems.enumerated()), id: \.offset) { _, date in
                if let date {
                    dayCell(for: date)
                } else {
                    Color.clear.frame(height: 54)
                }
            }
        }
        .frame(width: contentWidth, alignment: .leading)
    }

    private func dayCell(for date: Date) -> some View {
        let day = viewModel.startOfDay(for: date)
        let isToday = viewModel.isToday(day)
        let didHitGoal = achievedDates.contains(day)

        return VStack(spacing: 6) {
            Text("\(viewModel.dayNumber(for: day))")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)

            Circle()
                .fill(didHitGoal ? .orange : .white.opacity(0.16))
                .frame(width: 8, height: 8)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(didHitGoal ? Color.accent.opacity(0.22) : Color.white.opacity(0.04))
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
    let viewModel = GoalsCalendarViewModel()

    let calendar = Calendar.current
    let today = calendar.startOfDay(for: .now)

    let achievedDates: Set<Date> = [
        today,
        calendar.date(byAdding: .day, value: -1, to: today)!,
        calendar.date(byAdding: .day, value: -3, to: today)!,
        calendar.date(byAdding: .day, value: -5, to: today)!
    ]

    let monthGridItems = viewModel.monthGridItems()

    return GeometryReader { proxy in
        ZStack {
            AppBackgroundView()

            CalendarSectionView(
                monthTitle: viewModel.monthTitle,
                weekdaySymbols: viewModel.orderedWeekdaySymbols,
                gridItems: monthGridItems,
                achievedDates: achievedDates,
                columns: viewModel.gridColumns,
                contentWidth: proxy.size.width - 40,
                onPrevious: {},
                onNext: {},
                viewModel: viewModel
            )
            .padding(.horizontal, 20)
        }
    }
}
