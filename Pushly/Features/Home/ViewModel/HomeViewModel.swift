import Foundation
import AVFoundation
import Observation

@Observable
final class HomeViewModel {
    var showWorkout = false
    var isRequestingCameraPermission = false
    var showCameraPermissionAlert = false
    var cameraPermissionMessage = ""
    var canOpenSettings = false

    func totalReps(from sessions: [WorkoutSession]) -> Int {
        sessions.reduce(0) { $0 + $1.totalReps }
    }

    func todayReps(from sessions: [WorkoutSession]) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        return sessions.filter { $0.date >= start }.reduce(0) { $0 + $1.totalReps }
    }

    func thisWeekReps(from sessions: [WorkoutSession]) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        return sessions.filter { $0.date >= weekStart }.reduce(0) { $0 + $1.totalReps }
    }

    func streak(from sessions: [WorkoutSession]) -> Int {
        let calendar = Calendar.current
        let sessionDays = Set(sessions.map { calendar.startOfDay(for: $0.date) })

        var currentDate = calendar.startOfDay(for: Date())
        if !sessionDays.contains(currentDate) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate) else { return 0 }
            currentDate = yesterday
        }

        var count = 0
        while sessionDays.contains(currentDate) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previous
        }
        return count
    }

    func requestCameraAccessAndStartWorkout() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showWorkout = true

        case .notDetermined:
            isRequestingCameraPermission = true
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.isRequestingCameraPermission = false
                    if granted {
                        self.showWorkout = true
                    } else {
                        self.presentCameraPermissionAlert(
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
