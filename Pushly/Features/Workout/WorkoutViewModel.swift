//
//  WorkoutViewModel.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI
import SwiftData
import AVFoundation

@Observable
final class WorkoutViewModel {
    var isWorkoutActive: Bool = false
    var isPaused: Bool = false
    var elapsedTime: TimeInterval = 0
    var showSummary: Bool = false
    var completedSession: WorkoutSession?

    let cameraManager = CameraManager()
    let poseEstimator = PoseEstimator()
    let pushUpDetector = PushUpDetector()

    private var timer: Timer?
    private var startTime: Date?
    private var pausedElapsed: TimeInterval = 0
    private var isCameraPrepared: Bool = false

    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startWorkout() {
        prepareCameraPreview()
        pushUpDetector.reset()
        elapsedTime = 0
        pausedElapsed = 0
        isWorkoutActive = true
        isPaused = false
        showSummary = false
        completedSession = nil
        startTime = Date()

        startTimer()
    }

    func prepareCameraPreview() {
        guard !isCameraPrepared else { return }

        cameraManager.frameHandler = { [weak self] sampleBuffer in
            self?.poseEstimator.detectPose(in: sampleBuffer)
        }
        cameraManager.configure(position: .front)
        isCameraPrepared = true
    }

    func togglePause() {
        if isPaused {
            isPaused = false
            startTime = Date()
            startTimer()
        } else {
            isPaused = true
            pausedElapsed = elapsedTime
            timer?.invalidate()
            timer = nil
        }
    }

    func stopWorkout(modelContext: ModelContext) {
        timer?.invalidate()
        timer = nil
        cameraManager.stop()
        isCameraPrepared = false
        isWorkoutActive = false

        let calories = Double(pushUpDetector.repCount) * 0.45

        let session = WorkoutSession(
            totalReps: pushUpDetector.repCount,
            duration: elapsedTime,
            averageTempo: pushUpDetector.averageTempo,
            formScore: pushUpDetector.overallFormScore,
            calories: calories
        )

        if pushUpDetector.repCount > 0 {
            modelContext.insert(session)
        }

        completedSession = session
        showSummary = true
    }

    func teardownCameraPreview() {
        timer?.invalidate()
        timer = nil
        cameraManager.stop()
        isCameraPrepared = false
    }

    func processCurrentFrame() {
        let joints = poseEstimator.currentJoints
        pushUpDetector.processJoints(joints)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let startTime = self.startTime else { return }
            Task { @MainActor in
                self.elapsedTime = self.pausedElapsed + Date().timeIntervalSince(startTime)
            }
        }
    }
}
