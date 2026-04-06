//
//  HistoryView.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]

    @State private var viewModel = HistoryViewModel()
    @State private var selectedSession: WorkoutSession?

    var body: some View {
        let filtered = viewModel.filteredSessions(from: sessions)

        NavigationStack {
            ZStack {
                backgroundLayer

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        heroSection

                        HistoryPeriodPicker(selectedPeriod: $viewModel.selectedPeriod)

                        HistorySummaryRow(sessions: filtered, periodTitle: viewModel.sessionsSectionTitle)

                        HistorySessionsList(
                            sessionsSectionTitle: viewModel.sessionsSectionTitle,
                            sessions: filtered,
                            selectedSession: $selectedSession
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 120)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar { toolbar }
            .sheet(item: $selectedSession) { session in
                SummaryView(session: session) {
                    selectedSession = nil
                }
            }
        }
    }
}

private extension HistoryView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.generateMockSessions(in: modelContext)
            } label: {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.headline)
            }
        }
    }

    var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.07, blue: 0.12),
                    Color(red: 0.08, green: 0.05, blue: 0.09),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.accent.opacity(0.22))
                .frame(width: 260, height: 260)
                .blur(radius: 40)
                .offset(x: 120, y: -210)

            Circle()
                .fill(Color.orange.opacity(0.16))
                .frame(width: 220, height: 220)
                .blur(radius: 50)
                .offset(x: -150, y: -120)
        }
    }

    var heroSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TRAINING ARCHIVE")
                .font(.caption.weight(.bold))
                .tracking(2.4)
                .foregroundStyle(.white.opacity(0.58))

            Text("Sessions with more signal.")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text("Scan your volume, spot cleaner form, and jump into any workout recap from one place.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))

            HStack(spacing: 10) {
                StatPillView(title: "All Sessions", value: "\(sessions.count)")
                StatPillView(
                    title: "Last Logged",
                    value: sessions.first?.date.formatted(.dateTime.day().month(.abbreviated)) ?? "No Data"
                )
            }
        }
    }
}

#Preview {
    HistoryView()
}
