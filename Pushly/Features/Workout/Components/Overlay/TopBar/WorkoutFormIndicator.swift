//
//  WorkoutFormIndicator.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutFormIndicator: View {
    let quality: FormQuality

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(quality.formColor)
                .frame(width: 8, height: 8)
            Text(quality.label)
                .font(.caption.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: .capsule)
    }
}

#Preview {
    WorkoutFormIndicator(quality: .good)
}
