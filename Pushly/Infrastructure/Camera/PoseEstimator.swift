//
//  PoseEstimator.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import Vision
import CoreMedia

nonisolated enum BodyJointName: String, CaseIterable, Hashable, Sendable {
    case nose
    case leftShoulder
    case rightShoulder
    case leftElbow
    case rightElbow
    case leftWrist
    case rightWrist
    case leftHip
    case rightHip
    case leftKnee
    case rightKnee
    case leftAnkle
    case rightAnkle
}

nonisolated struct BodyTrackingFrame: Sendable, Equatable {
    let points: [BodyJointName: CGPoint]

    static let skeletonConnections: [(BodyJointName, BodyJointName)] = [
        (.nose, .leftShoulder),
        (.nose, .rightShoulder),
        (.leftShoulder, .rightShoulder),
        (.leftShoulder, .leftElbow),
        (.leftElbow, .leftWrist),
        (.rightShoulder, .rightElbow),
        (.rightElbow, .rightWrist),
        (.leftShoulder, .leftHip),
        (.rightShoulder, .rightHip),
        (.leftHip, .rightHip),
        (.leftHip, .leftKnee),
        (.leftKnee, .leftAnkle),
        (.rightHip, .rightKnee),
        (.rightKnee, .rightAnkle)
    ]

    static let highlightedJoints: Set<BodyJointName> = [
        .leftShoulder,
        .rightShoulder,
        .leftElbow,
        .rightElbow
    ]

    static let highlightedConnections: [(BodyJointName, BodyJointName)] = [
        (.leftShoulder, .leftElbow),
        (.leftElbow, .leftWrist),
        (.rightShoulder, .rightElbow),
        (.rightElbow, .rightWrist)
    ]
}

nonisolated struct BodyJoints: Sendable, Equatable {
    var leftShoulder: CGPoint?
    var rightShoulder: CGPoint?
    var leftElbow: CGPoint?
    var rightElbow: CGPoint?
    var leftWrist: CGPoint?
    var rightWrist: CGPoint?
    var leftHip: CGPoint?
    var rightHip: CGPoint?
    var leftKnee: CGPoint?
    var rightKnee: CGPoint?
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

    var trackingFrame: BodyTrackingFrame {
        var points: [BodyJointName: CGPoint] = [:]

        points[.nose] = nose
        points[.leftShoulder] = leftShoulder
        points[.rightShoulder] = rightShoulder
        points[.leftElbow] = leftElbow
        points[.rightElbow] = rightElbow
        points[.leftWrist] = leftWrist
        points[.rightWrist] = rightWrist
        points[.leftHip] = leftHip
        points[.rightHip] = rightHip
        points[.leftKnee] = leftKnee
        points[.rightKnee] = rightKnee
        points[.leftAnkle] = leftAnkle
        points[.rightAnkle] = rightAnkle

        return BodyTrackingFrame(points: points.compactMapValues { $0 })
    }
}

@Observable
class PoseEstimator {
    var currentJoints: BodyJoints = BodyJoints()
    var isDetectingPose: Bool = false

    var trackingFrame: BodyTrackingFrame {
        currentJoints.trackingFrame
    }

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
        joints.leftKnee = point(for: .leftKnee)
        joints.rightKnee = point(for: .rightKnee)
        joints.leftAnkle = point(for: .leftAnkle)
        joints.rightAnkle = point(for: .rightAnkle)
        joints.nose = point(for: .nose)

        return joints
    }
}
