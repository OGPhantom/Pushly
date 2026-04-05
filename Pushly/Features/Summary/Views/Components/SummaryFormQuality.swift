//
//  SummaryFormQuality.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SummaryFormQuality: View {
    let session: WorkoutSession

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Technique Readout")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            HStack(alignment: .center, spacing: 22) {
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.08), lineWidth: 16)

                    Circle()
                        .trim(from: 0, to: clampedScore)
                        .stroke(
                            AngularGradient(
                                colors: [.yellow, .orange, .accent, .pink],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 4) {
                        Text("\(Int(clampedScore * 100))%")
                            .font(.title.weight(.black))
                            .foregroundStyle(.white)

                        Text(qualityLabel)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white.opacity(0.72))
                    }
                }
                .frame(width: 134, height: 134)

                VStack(alignment: .leading, spacing: 12) {
                    insightBar(title: "Form", value: clampedScore, tint: .accent)
                    insightBar(title: "Pacing", value: paceScore, tint: .orange)
                    insightBar(title: "Efficiency", value: efficiencyScore, tint: .green)

                    Text(coachNote)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.72))
                        .padding(.top, 4)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Focus next")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                Text(focusText)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(22)
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.10),
                    Color.white.opacity(0.04)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

private extension SummaryFormQuality {
    var clampedScore: Double {
        min(max(session.formScore, 0), 1)
    }

    var paceScore: Double {
        guard session.averageTempo > 0 else { return 0.32 }
        let difference = min(abs(session.averageTempo - 1.8), 1.8)
        return max(0.24, 1 - (difference / 1.8))
    }

    var efficiencyScore: Double {
        guard session.duration > 0 else { return 0 }
        let repsPerMinute = Double(session.totalReps) / max(session.duration / 60, 1)
        return min(repsPerMinute / 26, 1)
    }

    var qualityLabel: String {
        switch clampedScore {
        case 0.9...: return "Elite"
        case 0.78..<0.9: return "Sharp"
        case 0.62..<0.78: return "Stable"
        default: return "Learning"
        }
    }

    var coachNote: String {
        if clampedScore >= 0.9 {
            return "Your movement pattern stayed composed. This is the kind of set worth repeating."
        }
        if clampedScore >= 0.75 {
            return "Strong control overall. A touch more rhythm consistency would make this feel effortless."
        }
        return "Good base to build on. Slow the descent slightly and keep the top position cleaner."
    }

    var focusText: String {
        if paceScore < 0.5 {
            return "Your tempo drifted a bit. Aim for a more repeatable cadence across the full set."
        }
        if efficiencyScore < 0.45 {
            return "You were controlled but output stayed modest. Add volume gradually without rushing the reps."
        }
        return "Solid balance of pace and control. Keep the same depth and breathing pattern on the next session."
    }

    func insightBar(title: String, value: Double, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.58))

                Spacer()

                Text("\(Int(value * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.08))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [tint.opacity(0.8), tint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * value)
                }
            }
            .frame(height: 10)
        }
    }
}

#Preview {
    SummaryFormQuality(session: WorkoutSession(totalReps: 10, duration: 10, averageTempo: 1.8, formScore: 0.89))
}
