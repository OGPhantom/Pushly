//
//  PrimaryGradientButton.swift
//  Pushly
//
//  Created by Никита Сторчай on 28.02.2026.
//

import SwiftUI

struct PrimaryGradientButton<Content: View>: View {
    let height: CGFloat
    let width: CGFloat?
    let action: () -> Void
    let content: () -> Content

    var body: some View {
        Button(action: action) {
            content()
                .foregroundStyle(.white)
                .frame(maxWidth: width)
                .frame(height: height)
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
    PrimaryGradientButton(height: 60, width: .infinity) {

    } content: {
        HStack(spacing: 12) {
            Image(systemName: "play.fill")
                .font(.title3)
            Text("Start Workout")
                .font(.title3.bold())
        }
    }

}
