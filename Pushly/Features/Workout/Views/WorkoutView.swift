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
    @State private var showEmptyWorkoutAlert = false

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
        .alert("No Push-Ups Recorded", isPresented: $showEmptyWorkoutAlert) {
            Button("Keep Training", role: .cancel) {}
            Button("Close Workout", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Finish Workout becomes available after at least one counted rep. If you want to leave without saving a session, close the workout instead.")
        }
    }
}

private extension WorkoutView {
    var workoutContent: some View {
        ZStack {
            overlayUI
        }
    }

    var overlayUI: some View {
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
                    if viewModel.hasRecordedReps {
                        viewModel.stopWorkout(modelContext: modelContext)
                    } else {
                        showEmptyWorkoutAlert = true
                    }
                },
                isPaused: viewModel.isPaused
            )
        }
        .padding()
    }

    var countdownOrStart: some View {
        WorkoutCountdownView {
            viewModel.startWorkout()
        }
    }

    @ViewBuilder
    var backgroundLayer: some View {
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

    var cameraLayer: some View {
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
