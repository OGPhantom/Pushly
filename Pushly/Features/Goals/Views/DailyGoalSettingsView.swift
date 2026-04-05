//
//  DailyGoalSettingsView.swift
//  Pushly
//
//  Created by Никита Сторчай on 05.04.2026.
//

import SwiftUI

struct DailyGoalSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(DailyGoalStorage.key) private var dailyGoal = DailyGoalStorage.defaultReps

    @State private var showInfoSheet = false
    @State private var showCustomGoal = false

    var snapshot: DailyGoalSnapshot {
        DailyGoalSnapshot(goal: dailyGoal, completedReps: todayReps)
    }

    let todayReps: Int
    private let presets = [25, 50, 75, 100, 150]

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundLayer

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        previewCard
                        presetsCard

                        if shouldShowCustomGoal {
                            customGoalCard
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    .animation(.spring(response: 0.32, dampingFraction: 0.86), value: shouldShowCustomGoal)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showInfoSheet) {
                notesCard
                    .presentationDetents([.height(240), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

private extension DailyGoalSettingsView {
    var isCustomGoalSelected: Bool {
        !presets.contains(dailyGoal)
    }

    var shouldShowCustomGoal: Bool {
        showCustomGoal || isCustomGoalSelected
    }

    var backgroundLayer: some View {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.05, blue: 0.10),
                Color(red: 0.08, green: 0.04, blue: 0.09),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var previewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("TODAY'S TARGET")
                    .font(.caption.weight(.bold))
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.54))

                Spacer()

                Button {
                    showInfoSheet = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(.white.opacity(0.10), in: Circle())
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        )
                    }
                .buttonStyle(.plain)
                .accessibilityLabel("How daily goal works")
            }

            Text("\(dailyGoal) reps")
                .font(.system(size: 44, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text(snapshot.isCompleted ? "You already cleared this goal today." : "\(snapshot.remainingReps) reps left with the current target.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))

            ProgressView(value: snapshot.progress)
                .tint(.orange)
                .scaleEffect(x: 1, y: 1.8, anchor: .center)
                .padding(.top, 8)
        }
        .navigationTitle("Daily Goal")
        .padding(22)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    var presetsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Presets")
                .font(.headline)
                .foregroundStyle(.white)

            Text("Pick a preset or open Custom only when you need a fine-tuned target.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.66))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 12)], spacing: 12) {
                ForEach(presets, id: \.self) { preset in
                    Button {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                            dailyGoal = preset
                            showCustomGoal = false
                        }
                    } label: {
                        Text("\(preset)")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(dailyGoal == preset ? .black : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(buttonBackground(isSelected: dailyGoal == preset))
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                        showCustomGoal = true
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text("Custom")
                            .font(.headline.weight(.bold))
                    }
                    .foregroundStyle((isCustomGoalSelected || showCustomGoal) ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(buttonBackground(isSelected: isCustomGoalSelected || showCustomGoal))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(22)
        .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    var customGoalCard: some View {
        VStack(alignment: .leading, spacing: 14) {
                    Text("Custom Goal")
                        .font(.headline)
                        .foregroundStyle(.white)


            Stepper(value: $dailyGoal, in: 5...300, step: 5) {
                HStack {
                    Text("Goal")
                        .foregroundStyle(.white.opacity(0.7))

                    Spacer()

                    Text("\(dailyGoal) reps")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .font(.subheadline)
            }
            .tint(.orange)

            Slider(
                value: Binding(
                    get: { Double(dailyGoal) },
                    set: { dailyGoal = Int($0.rounded(.toNearestOrAwayFromZero) / 5) * 5 }
                ),
                in: 5...300,
                step: 5
            )
            .tint(.orange)
        }
        .padding(22)
        .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    @ViewBuilder
    func buttonBackground(isSelected: Bool) -> some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white, Color.white.opacity(0.78)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        } else {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )
        }
    }

    var notesCard: some View {
        ZStack {
            backgroundLayer

            VStack(alignment: .leading, spacing: 18) {
                Text("How it works")
                    .font(.headline)
                    .foregroundStyle(.white)

                noteRow(
                    icon: "checkmark.circle.fill",
                    text: "A day is complete once all sessions on that date add up to your target."
                )

                noteRow(
                    icon: "sparkles",
                    text: "Goal changes update Home progress and calendar achievements instantly."
                )
            }
            .padding(22)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.08), lineWidth: 1)
            )
            .padding(20)
        }
    }

    func noteRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.green)
                .frame(width: 18, height: 18)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))
        }
    }
}

#Preview {
    DailyGoalSettingsView(todayReps: 18)
}
