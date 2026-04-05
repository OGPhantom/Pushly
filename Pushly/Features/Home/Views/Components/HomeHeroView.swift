//
//  HomeHeroView.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HomeHeroView: View {
    let todayReps: Int
    let totalReps: Int
    let streak: Int

    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.92, green: 0.35, blue: 0.21),
                            Color(red: 0.73, green: 0.15, blue: 0.22),
                            Color(red: 0.29, green: 0.08, blue: 0.16)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(.white.opacity(0.14))
                        .frame(width: 210, height: 210)
                        .blur(radius: 6)
                        .offset(x: 48, y: -62)
                }

            VStack(alignment: .center, spacing: 22) {
                    ZStack {
                        BreathingGlowView()
                            .frame(width: 70, height: 70)

                        VStack(spacing: 2) {
                            Text("\(todayReps)")
                                .font(.system(size: 64, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                                .contentTransition(.numericText())

                            Text("TODAY")
                                .font(.caption.weight(.bold))
                                .tracking(2.8)
                                .foregroundStyle(.white.opacity(0.68))
                        }
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    HomeHeroView(todayReps: 42, totalReps: 560, streak: 7)
}
