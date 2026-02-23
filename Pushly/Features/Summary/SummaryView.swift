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
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 28) {
                    SummaryHeader(date: session.date)

                    SummaryMetricGrid(totalReps: session.totalReps, duration: session.formattedDuration, averageTempo: session.averageTempo, calories: session.formattedCalories)

                    SummaryFormQuality(formScore: session.formScore)
                }
                .padding(.horizontal)
                .padding(.top, 40)
                .padding(.bottom, 24)
            }

            SummaryDismissButton(onDismissTapped: onDismiss)
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
}
