//
//  PushUpDetector.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import Foundation
import SwiftUI

nonisolated enum PushUpPhase: Sendable {
    case idle
    case lowering
    case bottomReached
    case rising
    case repetitionCompleted

    var label: String {
        switch self {
        case .idle: return "idle"
        case .lowering: return "lowering"
        case .bottomReached: return "bottom"
        case .rising: return "rising"
        case .repetitionCompleted: return "done"
        }
    }
}

nonisolated enum FormQuality: Sendable {
    case good
    case warning
    case bad

    var label: String {
        switch self {
        case .good: return "Good Form"
        case .warning: return "Watch Form"
        case .bad: return "Fix Form"
        }
    }

    var formColor: Color {
        switch self {
        case .good: return .green
        case .warning: return .orange
        case .bad: return .red
        }
    }
}

@Observable
class PushUpDetector {
    var phase: PushUpPhase = .idle
    var repCount: Int = 0
    var formQuality: FormQuality = .good
    var currentElbowAngle: Double = 180
    var hipAlignmentScore: Double = 1.0
    var currentMotionScore: Double = 0
    var currentMotionRange: Double = 0

    private var repTimestamps: [Date] = []
    private var formScores: [Double] = []
    private var smoothedMotionScore: Double?
    private var observedTopMotion: Double?
    private var observedBottomMotion: Double?
    private var previousMotionScore: Double?
    private var lastRepAt: Date?

    private let downThreshold: Double = 115
    private let upThreshold: Double = 155
    private let hipDeviationThreshold: Double = 0.15
    private let minimumMotionRangeForRep: Double = 0.18
    private let minimumRepInterval: TimeInterval = 0.45

    var averageTempo: Double {
        guard repTimestamps.count >= 2 else { return 0 }
        let intervals = zip(repTimestamps.dropFirst(), repTimestamps).map { $0.timeIntervalSince($1) }
        return intervals.reduce(0, +) / Double(intervals.count)
    }

    var overallFormScore: Double {
        guard !formScores.isEmpty else { return 1.0 }
        return formScores.reduce(0, +) / Double(formScores.count)
    }

    func processJoints(_ joints: BodyJoints) {
        guard joints.isValid else { return }

        guard let rawMotionScore = calculateFrontMotionScore(joints) else { return }

        let smoothedScore = smoothMotion(rawMotionScore)
        currentMotionScore = smoothedScore
        updateMotionCalibration(with: smoothedScore)

        let elbowAngle = calculateElbowAngle(joints)
        let alignment = calculateHipAlignment(joints)

        currentElbowAngle = elbowAngle ?? 180
        hipAlignmentScore = alignment

        updateFormQuality(elbowAngle: elbowAngle, alignment: alignment)
        updateStateMachine(motionScore: smoothedScore, elbowAngle: elbowAngle)
    }

    func reset() {
        phase = .idle
        repCount = 0
        formQuality = .good
        currentElbowAngle = 180
        hipAlignmentScore = 1.0
        currentMotionScore = 0
        currentMotionRange = 0
        repTimestamps = []
        formScores = []
        smoothedMotionScore = nil
        observedTopMotion = nil
        observedBottomMotion = nil
        previousMotionScore = nil
        lastRepAt = nil
    }

    private func calculateElbowAngle(_ joints: BodyJoints) -> Double? {
        if let angle = calculateElbowAngleForSide(
            shoulder: joints.leftShoulder,
            elbow: joints.leftElbow,
            wrist: joints.leftWrist
        ) {
            return angle
        }

        return calculateElbowAngleForSide(
            shoulder: joints.rightShoulder,
            elbow: joints.rightElbow,
            wrist: joints.rightWrist
        )
    }

    private func calculateElbowAngleForSide(shoulder: CGPoint?, elbow: CGPoint?, wrist: CGPoint?) -> Double? {
        guard let shoulder, let elbow, let wrist else { return nil }

        return angleBetweenPoints(a: shoulder, b: elbow, c: wrist)
    }

    private func calculateHipAlignment(_ joints: BodyJoints) -> Double {
        guard let shoulder = midpoint(joints.leftShoulder, joints.rightShoulder),
              let hip = midpoint(joints.leftHip, joints.rightHip) else { return 1.0 }

        let ankle = midpoint(joints.leftAnkle, joints.rightAnkle) ?? hip

        let shoulderToAnkle = distance(shoulder, ankle)
        guard shoulderToAnkle > 0.01 else { return 1.0 }

        let hipDeviation = perpendicularDistance(point: hip, lineStart: shoulder, lineEnd: ankle) / shoulderToAnkle
        return max(0, 1.0 - hipDeviation * 5)
    }

    private func updateFormQuality(elbowAngle: Double?, alignment: Double) {
        let alignmentOk = alignment > (1.0 - hipDeviationThreshold)

        if alignment < 0.5 {
            formQuality = .bad
        } else if !alignmentOk || (phase == .bottomReached && (elbowAngle ?? 180) > downThreshold + 20) {
            formQuality = .warning
        } else if currentMotionRange < minimumMotionRangeForRep * 0.7 {
            formQuality = .warning
        } else {
            formQuality = .good
        }
    }

    private func updateStateMachine(motionScore: Double, elbowAngle: Double?) {
        guard let observedTopMotion, let observedBottomMotion else { return }

        let range = observedTopMotion - observedBottomMotion
        currentMotionRange = max(0, range)
        guard range >= minimumMotionRangeForRep else {
            phase = .idle
            previousMotionScore = motionScore
            return
        }

        let delta = motionScore - (previousMotionScore ?? motionScore)
        previousMotionScore = motionScore

        let topThreshold = observedBottomMotion + range * 0.68
        let bottomThreshold = observedBottomMotion + range * 0.34
        let movingDown = delta < -0.004
        let movingUp = delta > 0.004

        let elbowBottomConfirmed = (elbowAngle ?? 180) <= downThreshold
        let elbowTopConfirmed = (elbowAngle ?? 0) >= upThreshold
        let bottomDetected = motionScore <= bottomThreshold || (motionScore <= observedBottomMotion + range * 0.45 && elbowBottomConfirmed)
        let topDetected = motionScore >= topThreshold || elbowTopConfirmed

        switch phase {
        case .idle:
            if movingDown && motionScore < topThreshold {
                phase = .lowering
            }
        case .lowering:
            if bottomDetected {
                phase = .bottomReached
            } else if topDetected && !movingDown {
                phase = .idle
            }
        case .bottomReached:
            if movingUp || motionScore > observedBottomMotion + range * 0.42 {
                phase = .rising
            }
        case .rising:
            if topDetected {
                phase = .repetitionCompleted
                completeRep()
            } else if bottomDetected {
                phase = .bottomReached
            }
        case .repetitionCompleted:
            phase = .idle
        }
    }

    private func completeRep() {
        let now = Date()
        if let lastRepAt, now.timeIntervalSince(lastRepAt) < minimumRepInterval {
            return
        }
        lastRepAt = now

        repCount += 1
        repTimestamps.append(now)

        let score: Double
        switch formQuality {
        case .good: score = 1.0
        case .warning: score = 0.6
        case .bad: score = 0.3
        }
        formScores.append(score)
    }

    private func calculateFrontMotionScore(_ joints: BodyJoints) -> Double? {
        guard let shoulderAnchor = midpoint(joints.leftShoulder, joints.rightShoulder) ?? joints.leftShoulder ?? joints.rightShoulder else {
            return nil
        }

        let wristAnchor = midpoint(joints.leftWrist, joints.rightWrist) ?? joints.leftWrist ?? joints.rightWrist
        let elbowAnchor = midpoint(joints.leftElbow, joints.rightElbow) ?? joints.leftElbow ?? joints.rightElbow
        guard let armAnchor = wristAnchor ?? elbowAnchor else { return nil }

        let shoulderWidth = {
            if let left = joints.leftShoulder, let right = joints.rightShoulder {
                return max(distance(left, right), 0.05)
            }
            if let elbowAnchor {
                return max(distance(shoulderAnchor, elbowAnchor) * 0.8, 0.05)
            }
            return 0.08
        }()

        let shoulderSpan = (shoulderAnchor.y - armAnchor.y) / shoulderWidth
        if let nose = joints.nose {
            let headSpan = (nose.y - armAnchor.y) / shoulderWidth
            return (shoulderSpan * 0.7) + (headSpan * 0.3)
        }
        return shoulderSpan
    }

    private func smoothMotion(_ value: Double) -> Double {
        let nextValue: Double
        if let smoothedMotionScore {
            nextValue = smoothedMotionScore * 0.75 + value * 0.25
        } else {
            nextValue = value
        }
        smoothedMotionScore = nextValue
        return nextValue
    }

    private func updateMotionCalibration(with motionScore: Double) {
        if let top = observedTopMotion {
            observedTopMotion = max(motionScore, top * 0.995 + motionScore * 0.005)
        } else {
            observedTopMotion = motionScore
        }

        if let bottom = observedBottomMotion {
            observedBottomMotion = min(motionScore, bottom * 0.995 + motionScore * 0.005)
        } else {
            observedBottomMotion = motionScore
        }

        if let observedTopMotion, let observedBottomMotion {
            currentMotionRange = max(0, observedTopMotion - observedBottomMotion)
        }
    }

    private func angleBetweenPoints(a: CGPoint, b: CGPoint, c: CGPoint) -> Double {
        let ba = CGPoint(x: a.x - b.x, y: a.y - b.y)
        let bc = CGPoint(x: c.x - b.x, y: c.y - b.y)
        let dotProduct = ba.x * bc.x + ba.y * bc.y
        let magnitudeBA = sqrt(ba.x * ba.x + ba.y * ba.y)
        let magnitudeBC = sqrt(bc.x * bc.x + bc.y * bc.y)
        guard magnitudeBA > 0, magnitudeBC > 0 else { return 180 }
        let cosAngle = max(-1, min(1, dotProduct / (magnitudeBA * magnitudeBC)))
        return acos(cosAngle) * 180 / .pi
    }

    private func midpoint(_ a: CGPoint?, _ b: CGPoint?) -> CGPoint? {
        guard let a, let b else { return a ?? b }
        return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }

    private func distance(_ a: CGPoint, _ b: CGPoint) -> Double {
        sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }

    private func perpendicularDistance(point: CGPoint, lineStart: CGPoint, lineEnd: CGPoint) -> Double {
        let dx = lineEnd.x - lineStart.x
        let dy = lineEnd.y - lineStart.y
        let length = sqrt(dx * dx + dy * dy)
        guard length > 0 else { return 0 }
        return abs(dy * point.x - dx * point.y + lineEnd.x * lineStart.y - lineEnd.y * lineStart.x) / length
    }
}
