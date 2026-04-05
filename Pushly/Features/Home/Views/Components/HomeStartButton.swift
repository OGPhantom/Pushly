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
        PrimaryGradientButton(height: 60, width: .infinity) {
            onTap()
        } content: {
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
        }
        .disabled(isLoading)

    }
}

#Preview {
    HomeStartButton(isLoading: false) {
        //
    }
}
