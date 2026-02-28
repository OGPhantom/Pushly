//
//  WorkoutPauseButton.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutPauseButton: View {
    let onPauseTapped: () -> Void
    let isPaused: Bool

    var body: some View {
        Button {
            onPauseTapped()
        } label: {
            Image(systemName: isPaused ? "play.fill" : "pause.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(.ultraThinMaterial, in: .circle)
        }
    }
}

#Preview {
    WorkoutPauseButton(onPauseTapped: {
        //
    }, isPaused: true)
}
