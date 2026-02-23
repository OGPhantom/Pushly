//
//  WorkoutView.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI
import SwiftData
import AVFoundation

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = WorkoutViewModel()

    var body: some View {
        ZStack {
            backgroundLayer

            if viewModel.isWorkoutActive {
                workoutContent
            } else if viewModel.showSummary, let session = viewModel.completedSession {
                SummaryView(session: session) {
                    dismiss()
                }
            } else {
                countdownOrStart
            }
        }
        .statusBarHidden(viewModel.isWorkoutActive)
        .onChange(of: viewModel.poseEstimator.currentJoints) { _, _ in
            viewModel.processCurrentFrame()
        }
        .onAppear {
#if !targetEnvironment(simulator)
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                viewModel.prepareCameraPreview()
            }
#endif
        }
        .onDisappear {
            viewModel.teardownCameraPreview()
        }
    }
}

private extension WorkoutView {
    private var workoutContent: some View {
        ZStack {
            overlayUI
        }
    }

    private var overlayUI: some View {
        VStack {
            WorkoutTopBar(isPaused: viewModel.isPaused, timeText: viewModel.formattedTime, quality: viewModel.pushUpDetector.formQuality)
            Spacer()
            WorkoutRepCounterView(repCount: viewModel.pushUpDetector.repCount)
            Spacer()

            WorkoutBottomBar(
                onPauseTapped: {
                    viewModel.togglePause()
                },
                onCloseTapped: {
                    dismiss()
                },
                onFinishConfirmed: {
                    viewModel.stopWorkout(modelContext: modelContext)
                },
                isPaused: viewModel.isPaused
            )
        }
        .padding()
    }

    private var countdownOrStart: some View {
        WorkoutCountdownView {
            viewModel.startWorkout()
        }
    }

    @ViewBuilder
    private var backgroundLayer: some View {
        if viewModel.showSummary, viewModel.completedSession != nil {
            Color.black.ignoresSafeArea()
        } else {
            cameraLayer
                .overlay {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.30),
                            Color.clear,
                            Color.black.opacity(0.35)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
        }
    }

    private var cameraLayer: some View {
        Group {
#if targetEnvironment(simulator)
            CameraUnavailablePlaceholder()
#else
            if AVCaptureDevice.default(for: .video) != nil {
                CameraPreview(session: viewModel.cameraManager.captureSession)
                    .ignoresSafeArea()
            } else {
                CameraUnavailablePlaceholder()
            }
#endif
        }
    }
}

#Preview {
    WorkoutView()
}
