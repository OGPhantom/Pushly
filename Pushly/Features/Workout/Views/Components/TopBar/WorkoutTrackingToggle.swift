//
//  WorkoutTrackingToggle.swift
//  Pushly
//
//  Created by Никита Сторчай on 08.04.2026.
//

import SwiftUI

struct WorkoutTrackingToggle: View {
    let isEnabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: isEnabled ? "eye.fill" : "eye.slash.fill")
                    .font(.caption.weight(.bold))
                Text("Tracking")
                    .font(.caption.bold())
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(backgroundFill, in: .capsule)
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isEnabled ? "Hide Tracking Overlay" : "Show Tracking Overlay")
    }

    private var backgroundFill: Color {
        isEnabled ? Color.accent.opacity(0.28) : Color.white.opacity(0.12)
    }

    private var borderColor: Color {
        isEnabled ? Color.accent.opacity(0.52) : Color.white.opacity(0.14)
    }
}

#Preview {
    VStack(spacing: 12) {
        WorkoutTrackingToggle(isEnabled: false, onTap: {})
        WorkoutTrackingToggle(isEnabled: true, onTap: {})
    }
    .padding()
    .background(.black)
}
