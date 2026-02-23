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
    @State private var showStopConfirmation: Bool = false

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

    private var countdownOrStart: some View {
        CountdownView {
            viewModel.startWorkout()
        }
    }

    private var workoutContent: some View {
        ZStack {
            overlayUI
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

    private var overlayUI: some View {
        VStack {
            topBar
//            debugHUD
            Spacer()
            repCounter
            Spacer()
            bottomBar
        }
        .padding()
    }

    private var topBar: some View {
        HStack {
            timerPill

            Spacer()

            formIndicator
        }
        .padding(.top, 8)
    }

    private var debugHUD: some View {
        VStack(alignment: .leading, spacing: 4) {
            debugRow("camera", viewModel.cameraManager.captureSession.isRunning ? "running" : "stopped")
            debugRow("pose", viewModel.poseEstimator.currentJoints.isValid ? "valid" : "invalid")
            debugRow("phase", viewModel.pushUpDetector.phase.label)
            debugRow("elbow", String(format: "%.0f°", viewModel.pushUpDetector.currentElbowAngle))
            debugRow("motion", String(format: "%.2f", viewModel.pushUpDetector.currentMotionScore))
            debugRow("range", String(format: "%.2f", viewModel.pushUpDetector.currentMotionRange))
            debugRow("hips", String(format: "%.2f", viewModel.pushUpDetector.hipAlignmentScore))
            debugRow("reps", "\(viewModel.pushUpDetector.repCount)")
        }
        .font(.system(.caption2, design: .monospaced))
        .foregroundStyle(.white)
        .padding(10)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func debugRow(_ key: String, _ value: String) -> some View {
        HStack(spacing: 8) {
            Text(key)
                .foregroundStyle(.white.opacity(0.75))
                .frame(width: 44, alignment: .leading)
            Text(value)
                .bold()
        }
    }

    private var timerPill: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(viewModel.isPaused ? .orange : .red)
                .frame(width: 8, height: 8)
            Text(viewModel.formattedTime)
                .font(.system(.body, design: .monospaced).bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: .capsule)
    }

    private var formIndicator: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(formColor)
                .frame(width: 8, height: 8)
            Text(viewModel.pushUpDetector.formQuality.label)
                .font(.caption.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: .capsule)
    }

    private var formColor: Color {
        switch viewModel.pushUpDetector.formQuality {
        case .good: return .green
        case .warning: return .orange
        case .bad: return .red
        }
    }

    private var repCounter: some View {
        VStack(spacing: 4) {
            Text("\(viewModel.pushUpDetector.repCount)")
                .font(.system(size: 96, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.3), value: viewModel.pushUpDetector.repCount)
                .shadow(color: .black.opacity(0.5), radius: 10)

            Text("REPS")
                .font(.title3.bold())
                .foregroundStyle(.white.opacity(0.7))
                .tracking(4)
        }
        .sensoryFeedback(.impact(weight: .heavy), trigger: viewModel.pushUpDetector.repCount)
    }

    private var bottomBar: some View {
        HStack(spacing: 20) {
            Button {
                viewModel.togglePause()
            } label: {
                Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.ultraThinMaterial, in: .circle)
            }

            Button {
                showStopConfirmation = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.headline)
                    Text("Finish Workout")
                        .font(.headline)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [Color("AccentColor"), Color("AccentColor").opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: .capsule
                )
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.ultraThinMaterial, in: .circle)
            }
        }
        .padding(.bottom, 16)
        .confirmationDialog("Finish Workout?", isPresented: $showStopConfirmation) {
            Button("Finish & Save") {
                viewModel.stopWorkout(modelContext: modelContext)
            }
            Button("Keep Training", role: .cancel) {}
        } message: {
            Text("Finish the session and save the summary?")
        }
    }
}

struct CameraUnavailablePlaceholder: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.5))
            Text("Camera Preview")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("Install this app on your device\nvia the Rork App to use the camera.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.darkGray))
    }
}

struct CountdownView: View {
    let onComplete: () -> Void
    @State private var count: Int = 3
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.black.opacity(0.18).ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Get Ready")
                    .font(.title2.bold())
                    .foregroundStyle(.white.opacity(0.9))

                Text("\(count)")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .scaleEffect(scale)
                    .animation(.spring(duration: 0.4, bounce: 0.5), value: scale)

                Text("Position yourself in frame")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(24)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 20))
            .padding()
        }
        .sensoryFeedback(.impact(weight: .light), trigger: count)
        .task {
            for i in stride(from: 3, through: 1, by: -1) {
                count = i
                scale = 1.3
                try? await Task.sleep(for: .milliseconds(100))
                scale = 1.0
                try? await Task.sleep(for: .milliseconds(900))
            }
            onComplete()
        }
    }
}


#Preview {
    WorkoutView()
}
