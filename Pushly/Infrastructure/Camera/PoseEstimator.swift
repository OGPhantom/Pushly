//
//  PoseEstimator.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import Vision
import CoreMedia

nonisolated struct BodyJoints: Sendable, Equatable {
    var leftShoulder: CGPoint?
    var rightShoulder: CGPoint?
    var leftElbow: CGPoint?
    var rightElbow: CGPoint?
    var leftWrist: CGPoint?
    var rightWrist: CGPoint?
    var leftHip: CGPoint?
    var rightHip: CGPoint?
    var leftAnkle: CGPoint?
    var rightAnkle: CGPoint?
    var nose: CGPoint?

    var hasLeftArmChain: Bool {
        leftShoulder != nil && leftElbow != nil && leftWrist != nil
    }

    var hasRightArmChain: Bool {
        rightShoulder != nil && rightElbow != nil && rightWrist != nil
    }

    var isValid: Bool {
        let hasShoulderReference = leftShoulder != nil || rightShoulder != nil
        let hasArmAnchor = leftWrist != nil || rightWrist != nil || leftElbow != nil || rightElbow != nil
        let hasFrontTrackingContext = hasLeftArmChain || hasRightArmChain || nose != nil || (leftShoulder != nil && rightShoulder != nil)

        return hasShoulderReference && hasArmAnchor && hasFrontTrackingContext
    }
}

@Observable
class PoseEstimator {
    var currentJoints: BodyJoints = BodyJoints()
    var isDetectingPose: Bool = false

    func detectPose(in sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard error == nil,
                  let results = request.results as? [VNHumanBodyPoseObservation],
                  let pose = results.first else {
                Task { @MainActor in
                    self?.currentJoints = BodyJoints()
                    self?.isDetectingPose = false
                }
                return
            }

            let joints = self?.extractJoints(from: pose) ?? BodyJoints()
            Task { @MainActor in
                self?.currentJoints = joints
                self?.isDetectingPose = joints.isValid
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        try? handler.perform([request])
    }

    private func extractJoints(from observation: VNHumanBodyPoseObservation) -> BodyJoints {
        var joints = BodyJoints()

        func point(for joint: VNHumanBodyPoseObservation.JointName) -> CGPoint? {
            guard let recognized = try? observation.recognizedPoint(joint),
                  recognized.confidence > 0.3 else { return nil }
            return recognized.location
        }

        joints.leftShoulder = point(for: .leftShoulder)
        joints.rightShoulder = point(for: .rightShoulder)
        joints.leftElbow = point(for: .leftElbow)
        joints.rightElbow = point(for: .rightElbow)
        joints.leftWrist = point(for: .leftWrist)
        joints.rightWrist = point(for: .rightWrist)
        joints.leftHip = point(for: .leftHip)
        joints.rightHip = point(for: .rightHip)
        joints.leftAnkle = point(for: .leftAnkle)
        joints.rightAnkle = point(for: .rightAnkle)
        joints.nose = point(for: .nose)

        return joints
    }
}
