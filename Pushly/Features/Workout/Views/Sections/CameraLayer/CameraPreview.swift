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

    func makeUIView(context: Context) -> UIView {
        let view = PreviewView(frame: .zero)
        view.previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer.session = session
        configurePreviewConnection(view.previewLayer.connection)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let previewView = uiView as? PreviewView else { return }
        previewView.previewLayer.videoGravity = .resizeAspectFill
        if previewView.previewLayer.session !== session {
            previewView.previewLayer.session = session
        }
        configurePreviewConnection(previewView.previewLayer.connection)
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
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}
