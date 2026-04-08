//
//  WorkoutTopBar.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutTopBar: View {
    let isPaused: Bool
    let timeText: String
    let quality: FormQuality
    let isTrackingVisible: Bool
    let onTrackingTapped: () -> Void

    var body: some View {
        HStack {
            WorkoutTimerPill(isPaused: isPaused, timeText: timeText)

            Spacer()

            HStack(spacing: 10) {
                WorkoutTrackingToggle(isEnabled: isTrackingVisible, onTap: onTrackingTapped)
                WorkoutFormIndicator(quality: quality)
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    WorkoutTopBar(
        isPaused: true,
        timeText: "00:10",
        quality: .good,
        isTrackingVisible: true,
        onTrackingTapped: {}
    )
}
