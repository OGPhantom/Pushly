//
//  HomeView.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI
import SwiftData
import AVFoundation
import UIKit

struct HomeView: View {
    @Environment(\.openURL) private var openURL

    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    var onOpenHistoryTab: (() -> Void)? = nil

    @State private var selectedSession: WorkoutSession?
    @State private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HomeHeroView(todayReps: viewModel.todayReps(from: sessions))

                    HomeStatsRow(thisWeekReps: viewModel.thisWeekReps(from: sessions), sessionsCount: sessions.count, streak: viewModel.streak(from: sessions))

                    HomeStartButton(isLoading: viewModel.isRequestingCameraPermission) {
                        viewModel.requestCameraAccessAndStartWorkout()
                    }
                    .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.showWorkout)

                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Pushly")
            .fullScreenCover(isPresented: $viewModel.showWorkout) {
                WorkoutView()
            }
            .sheet(item: $selectedSession) { session in
                SummaryView(session: session) {
                    selectedSession = nil
                }
            }
            .alert("Camera Access Needed", isPresented: $viewModel.showCameraPermissionAlert) {
                if viewModel.canOpenSettings {
                    Button("Open Settings") {
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        openURL(settingsURL)
                    }
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.cameraPermissionMessage)
            }
        }
    }
}
#Preview {
    HomeView()
}
