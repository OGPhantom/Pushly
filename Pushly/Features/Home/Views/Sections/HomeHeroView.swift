//
//  HomeHeroView.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HomeHeroView: View {
    let todayReps: Int

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                BreathingGlowView()
                    .frame(width: 320, height: 320)

                VStack(spacing: 4) {
                    Text("Today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text("\(todayReps)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())

                    Text("Push Ups")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 320, height: 320)
        }
        .padding(.top, 20)
    }
}

#Preview {
    HomeHeroView(todayReps: 42)
}
