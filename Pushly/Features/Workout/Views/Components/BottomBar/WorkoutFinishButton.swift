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
        PrimaryGradientButton(height: 56, width: nil) {
            onFinishConfirmed()
        } content: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.headline)
                Text("Finish Workout")
                    .font(.headline)
            }
            .padding(.horizontal, 18)
        }
    }
}

#Preview {
    WorkoutFinishButton {
        //
    }
}
