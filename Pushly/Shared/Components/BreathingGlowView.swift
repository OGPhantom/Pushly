//
//  BreathingGlowView.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct BreathingGlowView: View {
    var body: some View {
        return TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let phase = (sin(time * Animation.frequency) + 1) / 2
            let opacity = Animation.baseOpacity + phase * Animation.opacityAmplitude
            let dynamicBlur = Animation.baseBlurScale + phase * Animation.blurAmplitude

            ZStack {
                Circle()
                    .fill(.accent.opacity(Layer.baseOpacity))
                    .frame(width: Layer.smallSize, height: Layer.smallSize)
                    .blur(radius: Layer.smallBlur * dynamicBlur)
                    .scaleEffect(1 + phase * Layer.smallScaleAmplitude)

                Circle()
                    .fill(.accent.opacity(Layer.baseOpacity * Layer.mediumOpacityMultiplier))
                    .frame(width: Layer.mediumSize, height: Layer.mediumSize)
                    .blur(radius: Layer.mediumBlur * dynamicBlur)
                    .scaleEffect(1 + phase * Layer.mediumScaleAmplitude)

                Circle()
                    .fill(.accent.opacity(Layer.baseOpacity * Layer.largeOpacityMultiplier))
                    .frame(width: Layer.largeSize, height: Layer.largeSize)
                    .blur(radius: Layer.largeBlur * dynamicBlur)
                    .scaleEffect(1 + phase * Layer.largeScaleAmplitude)
            }
            .opacity(opacity)
            .blendMode(.plusLighter)
        }
    }
}

private extension BreathingGlowView {
    private enum Animation {
        static let frequency: Double = 2.2
        static let baseOpacity: Double = 0.65
        static let opacityAmplitude: Double = 0.35
        static let blurAmplitude: CGFloat = 0.4
        static let baseBlurScale: CGFloat = 1.0
    }

    private enum Layer {
        static let smallSize: CGFloat = 180
        static let mediumSize: CGFloat = 240
        static let largeSize: CGFloat = 320

        static let smallBlur: CGFloat = 30
        static let mediumBlur: CGFloat = 60
        static let largeBlur: CGFloat = 90

        static let smallScaleAmplitude: CGFloat = 0.08
        static let mediumScaleAmplitude: CGFloat = 0.10
        static let largeScaleAmplitude: CGFloat = 0.14

        static let baseOpacity: Double = 0.55
        static let mediumOpacityMultiplier: Double = 0.6
        static let largeOpacityMultiplier: Double = 0.3
    }
}

#Preview {
    BreathingGlowView()
}
