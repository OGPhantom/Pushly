//
//  WorkoutCountdownView.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutCountdownView: View {
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
    WorkoutCountdownView {
        //
    }
}
