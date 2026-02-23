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
    @Environment(\.colorScheme) private var colorScheme
    @State private var isBreathing = false
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    var onOpenHistoryTab: (() -> Void)? = nil
    @State private var showWorkout: Bool = false
    @State private var selectedSession: WorkoutSession?
    @State private var showCameraPermissionAlert: Bool = false
    @State private var cameraPermissionMessage: String = ""
    @State private var canOpenSettings: Bool = false
    @State private var isRequestingCameraPermission: Bool = false

    private var totalReps: Int {
        sessions.reduce(0) { $0 + $1.totalReps }
    }

    private var thisWeekReps: Int {
        let calendar = Calendar.current
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return sessions.filter { $0.date >= weekStart }.reduce(0) { $0 + $1.totalReps }
    }

    private var streak: Int {
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: Date())
        var count = 0
        let sessionDays = Set(sessions.map { calendar.startOfDay(for: $0.date) })

        while sessionDays.contains(currentDate) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previous
        }
        return count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    heroSection

                    statsRow

                    startButton
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Pushly")
            .fullScreenCover(isPresented: $showWorkout) {
                WorkoutView()
            }
            .sheet(item: $selectedSession) { session in
                SummaryView(session: session) {
                    selectedSession = nil
                }
            }
            .alert("Camera Access Needed", isPresented: $showCameraPermissionAlert) {
                if canOpenSettings {
                    Button("Open Settings") {
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        openURL(settingsURL)
                    }
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text(cameraPermissionMessage)
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: 8) {
            ZStack {

                breathingGlow
                    .frame(width: 320, height: 320)

                VStack(spacing: 4) {
                    Text("\(totalReps)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())

                    Text("Push Ups")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 320, height: 320)
        }
        .padding(.top, 20)
    }

    private var breathingGlow: some View {
        let baseOpacity: Double = colorScheme == .dark ? 0.55 : 0.30
        let blurMultiplier: CGFloat = colorScheme == .dark ? 1.0 : 0.7

        return TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let phase = (sin(time * 2.2) + 1) / 2
            let opacity = 0.65 + phase * 0.35
            let dynamicBlur = 1 + phase * 0.4

            ZStack {
                Circle()
                    .fill(Color("AccentColor").opacity(baseOpacity))
                    .frame(width: 180, height: 180)
                    .blur(radius: 30 * blurMultiplier * dynamicBlur)
                    .scaleEffect(1 + phase * 0.08)

                Circle()
                    .fill(Color("AccentColor").opacity(baseOpacity * 0.6))
                    .frame(width: 240, height: 240)
                    .blur(radius: 60 * blurMultiplier * dynamicBlur)
                    .scaleEffect(1 + phase * 0.10)

                Circle()
                    .fill(Color("AccentColor").opacity(baseOpacity * 0.3))
                    .frame(width: 320, height: 320)
                    .blur(radius: 90 * blurMultiplier * dynamicBlur)
                    .scaleEffect(1 + phase * 0.14)
            }
            .opacity(opacity)
            .blendMode(colorScheme == .dark ? .plusLighter : .normal)
        }
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(title: "This Week", value: "\(thisWeekReps)", icon: "flame.fill", color: .orange)
            StatCard(title: "Sessions", value: "\(sessions.count)", icon: "figure.strengthtraining.traditional", color: .blue)
            StatCard(title: "Streak", value: "\(streak)d", icon: "bolt.fill", color: .yellow)
        }
    }

    private var startButton: some View {
        Button {
            requestCameraAccessAndStartWorkout()
        } label: {
            HStack(spacing: 12) {
                if isRequestingCameraPermission {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "play.fill")
                        .font(.title3)
                }

                Text(isRequestingCameraPermission ? "Requesting Camera..." : "Start Workout")
                    .font(.title3.bold())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                LinearGradient(
                    colors: [Color("AccentColor"), Color("AccentColor").opacity(0.82)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: .rect(cornerRadius: 16)
            )
        }
        .disabled(isRequestingCameraPermission)
        .sensoryFeedback(.impact(weight: .medium), trigger: showWorkout)
    }

    private func requestCameraAccessAndStartWorkout() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showWorkout = true

        case .notDetermined:
            isRequestingCameraPermission = true
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    isRequestingCameraPermission = false

                    if granted {
                        showWorkout = true
                    } else {
                        presentCameraPermissionAlert(
                            message: "Camera access is required to count your push-ups. You can enable it later in Settings.",
                            canOpenSettings: true
                        )
                    }
                }
            }

        case .denied:
            presentCameraPermissionAlert(
                message: "Camera access is turned off. Enable it in Settings to start a workout.",
                canOpenSettings: true
            )

        case .restricted:
            presentCameraPermissionAlert(
                message: "Camera access is restricted on this device and cannot be enabled for this app.",
                canOpenSettings: false
            )

        @unknown default:
            presentCameraPermissionAlert(
                message: "Unable to access the camera right now. Please try again.",
                canOpenSettings: false
            )
        }
    }

    private func presentCameraPermissionAlert(message: String, canOpenSettings: Bool) {
        cameraPermissionMessage = message
        self.canOpenSettings = canOpenSettings
        showCameraPermissionAlert = true
    }
}

#Preview {
    HomeView()
}
