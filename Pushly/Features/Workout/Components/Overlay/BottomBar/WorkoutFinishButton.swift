//
//  WorkoutFinishButton.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutFinishButton: View {
    let onFinishConfirmed: () -> Void

    var body: some View {
        Button {
            onFinishConfirmed()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.headline)
                Text("Finish Workout")
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [.accent, .accent.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: .capsule
            )
        }
    }
}

#Preview {
    WorkoutFinishButton {
        //
    }
}
