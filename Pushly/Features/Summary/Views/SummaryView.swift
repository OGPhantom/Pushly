//
//  SummaryView.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI

struct SummaryView: View {
    let session: WorkoutSession
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            backgroundLayer

            ScrollView {
                VStack(spacing: 20) {
                    SummaryHeader(session: session)

                    SummaryMetricGrid(session: session)

                    SummaryFormQuality(session: session)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
            .scrollIndicators(.hidden)
        }
    }
}

private extension SummaryView {
    var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.04, blue: 0.08),
                    Color(red: 0.10, green: 0.05, blue: 0.08),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.accent.opacity(0.26))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: 130, y: -250)

            Circle()
                .fill(Color.orange.opacity(0.18))
                .frame(width: 240, height: 240)
                .blur(radius: 50)
                .offset(x: -140, y: -180)
        }
    }
}

#Preview {
    SummaryView(session: WorkoutSession(totalReps: 10, duration: 10)) {
        //
    }
}
