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
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "play.fill")
                        .font(.title3)
                }

                Text(isLoading ? "Requesting Camera..." : "Start Workout")
                    .font(.title3.bold())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                LinearGradient(
                    colors: [Color("AccentColor"), Color("AccentColor").opacity(0.82)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: .rect(cornerRadius: 16)
            )
        }
        .disabled(isLoading)
    }
}

#Preview {
    HomeStartButton(isLoading: true) {
        //
    }
}
