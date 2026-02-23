//
//  WorkoutBottomBar.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutBottomBar: View {
    let onPauseTapped: () -> Void
    let onCloseTapped: () -> Void
    let onFinishConfirmed: () -> Void
    let isPaused: Bool

    var body: some View {
        HStack(spacing: 20) {
            WorkoutPauseButton(onPauseTapped: onPauseTapped, isPaused: isPaused)

            WorkoutFinishButton(onFinishConfirmed: onFinishConfirmed)

            WorkoutCloseButton(onCloseTapped: onCloseTapped)
        }
    }
}
