//
//  SummaryDismissButton.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SummaryDismissButton: View {
    let onDismissTapped: () -> Void

    var body: some View {
        Button {
            onDismissTapped()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "arrow.left")
                    .font(.subheadline.weight(.bold))

                Text("Back to Dashboard")
                    .font(.headline.weight(.bold))
            }
            .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(
                    LinearGradient(
                        colors: [Color.accent, Color.orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.accent.opacity(0.35), radius: 18, x: 0, y: 10)
        }
    }
}

#Preview {
    SummaryDismissButton {
        //
    }
}
