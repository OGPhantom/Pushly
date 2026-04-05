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
    @AppStorage(DailyGoalStorage.key) private var dailyGoal = DailyGoalStorage.defaultReps

    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    var onOpenHistoryTab: (() -> Void)? = nil

    @State private var selectedSession: WorkoutSession?
    @State private var viewModel = HomeViewModel()
    @State private var showDailyGoalSettings = false

    var body: some View {
        let todayReps = viewModel.todayReps(from: sessions)
        let weekReps = viewModel.thisWeekReps(from: sessions)
        let streak = viewModel.streak(from: sessions)
        let totalReps = viewModel.totalReps(from: sessions)
        let dailyGoalSnapshot = DailyGoalCalculator.snapshot(goal: dailyGoal, sessions: sessions)

        NavigationStack {
            ZStack {
                backgroundLayer

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        DailyGoalProgressCard(snapshot: dailyGoalSnapshot) {
                            showDailyGoalSettings = true
                        }

                        HomeHeroView(todayReps: todayReps, totalReps: totalReps, streak: streak)

                        HomeStatsRow(
                            thisWeekReps: weekReps,
                            sessionsCount: sessions.count,
                            streak: streak
                        )

                        HomeStartButton(
                            isLoading: viewModel.isRequestingCameraPermission) {
                            viewModel.requestCameraAccessAndStartWorkout()
                        }
                        .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.showWorkout)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 120)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Pushly")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showDailyGoalSettings = true
                    } label: {
                        Image(systemName: "target")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showWorkout) {
                WorkoutView()
            }
            .sheet(isPresented: $showDailyGoalSettings) {
                DailyGoalSettingsView(todayReps: dailyGoalSnapshot.completedReps)
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

private extension HomeView {
    var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.06, blue: 0.11),
                    Color(red: 0.08, green: 0.04, blue: 0.09),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.accent.opacity(0.24))
                .frame(width: 280, height: 280)
                .blur(radius: 55)
                .offset(x: 135, y: -240)

            Circle()
                .fill(Color.orange.opacity(0.18))
                .frame(width: 220, height: 220)
                .blur(radius: 48)
                .offset(x: -145, y: -120)
        }
    }
}

#Preview {
    HomeView()
}
