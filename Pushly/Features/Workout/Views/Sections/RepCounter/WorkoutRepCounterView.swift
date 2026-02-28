//
//  WorkoutRepCounterView.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutRepCounterView: View {
    let repCount: Int
    var body: some View {
        VStack(spacing: 4) {
            Text("\(repCount)")
                .font(.system(size: 96, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.3), value: repCount)
                .shadow(color: .black.opacity(0.5), radius: 10)

            Text("PUSH UPS")
                .font(.title3.bold())
                .foregroundStyle(.white.opacity(0.7))
                .tracking(4)
        }
        .sensoryFeedback(.impact(weight: .heavy), trigger: repCount)
    }
}

#Preview {
    WorkoutRepCounterView(repCount: 10)
}
