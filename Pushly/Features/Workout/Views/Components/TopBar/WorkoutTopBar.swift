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

    var body: some View {
        HStack {
            WorkoutTimerPill(isPaused: isPaused, timeText: timeText)

            Spacer()

            WorkoutFormIndicator(quality: quality)
        }
        .padding(.top, 8)
    }
}

#Preview {
    WorkoutTopBar(isPaused: true, timeText: "00:10", quality: .good)
}
