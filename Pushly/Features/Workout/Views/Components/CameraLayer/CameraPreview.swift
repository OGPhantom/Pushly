//
//  CameraPreview.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    let trackingFrame: BodyTrackingFrame?
    let quality: FormQuality
    let showsTrackingOverlay: Bool

    func makeUIView(context: Context) -> UIView {
        let view = PreviewView(frame: .zero)
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.session = session
        configurePreviewConnection(view.previewLayer.connection)
        view.renderTracking(frame: trackingFrame, quality: quality, isVisible: showsTrackingOverlay)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let previewView = uiView as? PreviewView else { return }
        previewView.previewLayer.videoGravity = .resizeAspectFill
        if previewView.previewLayer.session !== session {
            previewView.previewLayer.session = session
        }
        configurePreviewConnection(previewView.previewLayer.connection)
        previewView.renderTracking(frame: trackingFrame, quality: quality, isVisible: showsTrackingOverlay)
    }

    private func configurePreviewConnection(_ connection: AVCaptureConnection?) {
        guard let connection else { return }
        if connection.isVideoMirroringSupported {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = true
        }
    }
}

private final class PreviewView: UIView {
    private let trackingRenderer = BodyTrackingOverlayRenderer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = true
        trackingRenderer.attach(to: layer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        trackingRenderer.frame = bounds
    }

    func renderTracking(frame: BodyTrackingFrame?, quality: FormQuality, isVisible: Bool) {
        trackingRenderer.render(frame: frame, in: previewLayer, quality: quality, isVisible: isVisible)
    }
}

private final class BodyTrackingOverlayRenderer {
    private let containerLayer = CALayer()
    private let skeletonLayer = CAShapeLayer()
    private let highlightedSkeletonLayer = CAShapeLayer()
    private let jointsLayer = CAShapeLayer()
    private let highlightedJointsLayer = CAShapeLayer()

    var frame: CGRect = .zero {
        didSet {
            containerLayer.frame = frame
        }
    }

    init() {
        containerLayer.masksToBounds = true

        skeletonLayer.fillColor = UIColor.clear.cgColor
        skeletonLayer.lineCap = .round
        skeletonLayer.lineJoin = .round
        skeletonLayer.lineWidth = 3
        skeletonLayer.strokeColor = UIColor.white.withAlphaComponent(0.40).cgColor

        highlightedSkeletonLayer.fillColor = UIColor.clear.cgColor
        highlightedSkeletonLayer.lineCap = .round
        highlightedSkeletonLayer.lineJoin = .round
        highlightedSkeletonLayer.lineWidth = 4

        jointsLayer.fillColor = UIColor.white.withAlphaComponent(0.82).cgColor
        jointsLayer.strokeColor = UIColor.clear.cgColor

        highlightedJointsLayer.strokeColor = UIColor.clear.cgColor

        containerLayer.addSublayer(skeletonLayer)
        containerLayer.addSublayer(highlightedSkeletonLayer)
        containerLayer.addSublayer(jointsLayer)
        containerLayer.addSublayer(highlightedJointsLayer)
    }

    func attach(to parent: CALayer) {
        parent.addSublayer(containerLayer)
    }

    func render(frame: BodyTrackingFrame?, in previewLayer: AVCaptureVideoPreviewLayer, quality: FormQuality, isVisible: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        containerLayer.isHidden = !isVisible

        guard isVisible, let frame else {
            skeletonLayer.path = nil
            highlightedSkeletonLayer.path = nil
            jointsLayer.path = nil
            highlightedJointsLayer.path = nil
            CATransaction.commit()
            return
        }

        let qualityColor = UIColor(quality.formColor)
        highlightedSkeletonLayer.strokeColor = qualityColor.withAlphaComponent(0.82).cgColor
        highlightedJointsLayer.fillColor = qualityColor.withAlphaComponent(0.96).cgColor

        let convertedPoints = convert(frame.points, using: previewLayer)

        skeletonLayer.path = makeConnectionPath(
            for: BodyTrackingFrame.skeletonConnections,
            points: convertedPoints
        ).cgPath

        highlightedSkeletonLayer.path = makeConnectionPath(
            for: BodyTrackingFrame.highlightedConnections,
            points: convertedPoints
        ).cgPath

        jointsLayer.path = makeJointPath(
            from: convertedPoints,
            highlightedJoints: BodyTrackingFrame.highlightedJoints,
            includesHighlighted: false,
            radius: 4.5
        ).cgPath

        highlightedJointsLayer.path = makeJointPath(
            from: convertedPoints,
            highlightedJoints: BodyTrackingFrame.highlightedJoints,
            includesHighlighted: true,
            radius: 6
        ).cgPath

        CATransaction.commit()
    }

    private func convert(_ normalizedPoints: [BodyJointName: CGPoint], using previewLayer: AVCaptureVideoPreviewLayer) -> [BodyJointName: CGPoint] {
        var converted: [BodyJointName: CGPoint] = [:]

        for (joint, point) in normalizedPoints {
            let capturePoint = CGPoint(x: point.x, y: 1 - point.y)
            converted[joint] = previewLayer.layerPointConverted(fromCaptureDevicePoint: capturePoint)
        }

        return converted
    }

    private func makeConnectionPath(for connections: [(BodyJointName, BodyJointName)], points: [BodyJointName: CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()

        for (start, end) in connections {
            guard let startPoint = points[start], let endPoint = points[end] else { continue }
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }

        return path
    }

    private func makeJointPath(
        from points: [BodyJointName: CGPoint],
        highlightedJoints: Set<BodyJointName>,
        includesHighlighted: Bool,
        radius: CGFloat
    ) -> UIBezierPath {
        let path = UIBezierPath()

        for (joint, point) in points {
            let isHighlighted = highlightedJoints.contains(joint)
            guard isHighlighted == includesHighlighted else { continue }
            let rect = CGRect(
                x: point.x - radius,
                y: point.y - radius,
                width: radius * 2,
                height: radius * 2
            )
            path.append(UIBezierPath(ovalIn: rect))
        }

        return path
    }
}
