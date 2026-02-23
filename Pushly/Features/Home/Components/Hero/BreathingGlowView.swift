//
//  BreathingGlowView.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct BreathingGlowView: View {
    var body: some View {
        let baseOpacity: Double = 0.55
        let blurMultiplier: CGFloat = 1.0

        return TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let phase = (sin(time * 2.2) + 1) / 2
            let opacity = 0.65 + phase * 0.35
            let dynamicBlur = 1 + phase * 0.4

            ZStack {
                Circle()
                    .fill(Color("AccentColor").opacity(baseOpacity))
                    .frame(width: 180, height: 180)
                    .blur(radius: 30 * blurMultiplier * dynamicBlur)
                    .scaleEffect(1 + phase * 0.08)

                Circle()
                    .fill(Color("AccentColor").opacity(baseOpacity * 0.6))
                    .frame(width: 240, height: 240)
                    .blur(radius: 60 * blurMultiplier * dynamicBlur)
                    .scaleEffect(1 + phase * 0.10)

                Circle()
                    .fill(Color("AccentColor").opacity(baseOpacity * 0.3))
                    .frame(width: 320, height: 320)
                    .blur(radius: 90 * blurMultiplier * dynamicBlur)
                    .scaleEffect(1 + phase * 0.14)
            }
            .opacity(opacity)
            .blendMode(.plusLighter)
        }
    }
}

#Preview {
    BreathingGlowView()
}
