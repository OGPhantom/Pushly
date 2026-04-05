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
                        colors: [Color.accent, Color.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 28, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.accent.opacity(0.30), radius: 22, x: 0, y: 12)
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
