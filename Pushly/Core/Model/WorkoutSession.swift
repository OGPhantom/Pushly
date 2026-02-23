//
//  WorkoutSession.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import Foundation
import SwiftData

@Model
class WorkoutSession {
    var id: UUID
    var date: Date
    var totalReps: Int
    var duration: TimeInterval
    var averageTempo: Double
    var formScore: Double
    var calories: Double

    init(totalReps: Int, duration: TimeInterval, averageTempo: Double = 0, formScore: Double = 0, calories: Double = 0) {
        self.id = UUID()
        self.date = Date()
        self.totalReps = totalReps
        self.duration = duration
        self.averageTempo = averageTempo
        self.formScore = formScore
        self.calories = calories
    }
}
