//
//  HistoryView.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI
import SwiftData
import Charts

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]

    @State private var viewModel = HistoryViewModel()
    @State private var selectedSession: WorkoutSession?

    var body: some View {
        let filtered = viewModel.filteredSessions(from: sessions)
        let totalReps = viewModel.totalReps(from: sessions)
        let avgForm = viewModel.averageForm(from: sessions)

        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HistoryPeriodPicker(selectedPeriod: $viewModel.selectedPeriod)

                    HistorySummaryRow(totalReps: totalReps, sessionsCount: filtered.count, avgFormScore: avgForm)

                    HistorySessionsList(sessionsSectionTitle: viewModel.sessionsSectionTitle, sessions: filtered, selectedSession: $selectedSession)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.generateMockSessions(in: modelContext)
                    } label: {
                        Label("Mock Sessions", systemImage: "sparkles")
                    }
                }
            }
            .sheet(item: $selectedSession) { session in
                SummaryView(session: session) {
                    selectedSession = nil
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
