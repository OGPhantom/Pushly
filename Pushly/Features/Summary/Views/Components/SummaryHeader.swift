//
//  SummaryHeader.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SummaryHeader: View {
    let session: WorkoutSession

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.93, green: 0.34, blue: 0.22),
                            Color(red: 0.80, green: 0.18, blue: 0.20),
                            Color(red: 0.35, green: 0.10, blue: 0.16)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(.white.opacity(0.16))
                        .frame(width: 180, height: 180)
                        .blur(radius: 4)
                        .offset(x: 48, y: -54)
                }

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Label("Workout captured", systemImage: "checkmark.seal.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background(.white.opacity(0.14), in: Capsule())

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Session\nlocked in.")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text(session.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.76))
                }

                HStack(alignment: .lastTextBaseline, spacing: 10) {
                    Text("\(session.totalReps)")
                        .font(.system(size: 84, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text("REPS")
                        .font(.headline.weight(.bold))
                        .tracking(3)
                        .foregroundStyle(.white.opacity(0.74))
                        .padding(.bottom, 14)
                }

                Text("Solid finish. Your recap below breaks down pace, workload, and form quality from this set.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.80))

                HStack(spacing: 10) {
                    infoChip(title: "Duration", value: session.formattedDuration)
                    infoChip(title: "Calories", value: "\(session.formattedCalories) kcal")
                }
            }
            .padding(24)
        }
    }
}

private extension SummaryHeader {
    func infoChip(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.white.opacity(0.74))

            Text(value)
                .font(.title3.weight(.black))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.black.opacity(0.16), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    SummaryHeader(session: WorkoutSession(totalReps: 10, duration: 10))
}
