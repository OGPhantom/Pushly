//
//  CardBackgroundModifier.swift
//  Pushly
//
//  Created by Никита Сторчай on 06.04.2026.
//

import SwiftUI

struct CardBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(22)
            .background(
                LinearGradient(
                    colors: [
                        Color.accent.opacity(0.24),
                        Color.white.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(.white.opacity(0.10), lineWidth: 1)
            )
    }
}
