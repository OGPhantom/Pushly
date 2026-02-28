//
//  CameraManager.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import AVFoundation
import SwiftUI

class CameraManager: NSObject {
    let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.pushups.cameraQueue")
    private let videoOutputQueue = DispatchQueue(label: "com.pushups.videoQueue")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var frameCount: Int = 0

    var frameHandler: ((CMSampleBuffer) -> Void)?

    func configure(position: AVCaptureDevice.Position = .front) {
        sessionQueue.async { [weak self] in
            self?.setupSession(position: position)
        }
    }

    private func setupSession(position: AVCaptureDevice.Position) {
        frameCount = 0
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        captureSession.inputs.forEach { captureSession.removeInput($0) }
        captureSession.outputs.forEach { captureSession.removeOutput($0) }

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            captureSession.commitConfiguration()
            return
        }

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        if let connection = videoOutput.connection(with: .video) {
            connection.videoRotationAngle = 90
            if position == .front {
                connection.isVideoMirrored = true
            }
        }

        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    func stop() {
        sessionQueue.async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameCount += 1
        guard frameCount % 3 == 0 else { return }
        let handler = frameHandler
        handler?(sampleBuffer)
    }
}
