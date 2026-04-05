//
//  DailyGoalSnapshot.swift
//  Pushly
//
//  Created by Никита Сторчай on 05.04.2026.
//


struct DailyGoalSnapshot {
    let goal: Int
    let completedReps: Int

    var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(completedReps) / Double(goal), 1)
    }

    var remainingReps: Int {
        max(goal - completedReps, 0)
    }

    var isCompleted: Bool {
        completedReps >= goal
    }
}
