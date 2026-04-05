//
//  HomeStartButton.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HomeStartButton: View {
    let isLoading: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                onTap()
            } label: {
                HStack(spacing: 16) {

                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.14))
                            .frame(width: 46, height: 46)

                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "play.fill")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                                .offset(x: 1)
                        }
                    }

                    Text(isLoading ? "Requesting camera..." : "Start Workout")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)

                    Spacer()
                }
            }
            .padding(20)
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
        .disabled(isLoading)
    }
}

#Preview {
    HomeStartButton(isLoading: false) {
        //
    }
}
