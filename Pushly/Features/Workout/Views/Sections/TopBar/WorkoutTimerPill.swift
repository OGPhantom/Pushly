//
//  WorkoutTimerPill.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutTimerPill: View {
    let isPaused: Bool
    let timeText: String
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isPaused ? .orange : .red)
                .frame(width: 8, height: 8)
            Text(timeText)
                .font(.system(.body, design: .monospaced).bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: .capsule)
    }
}

#Preview {
    WorkoutTimerPill(isPaused: false, timeText: "00:10")
}
