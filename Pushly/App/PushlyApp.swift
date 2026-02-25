//
//  PushlyApp.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI
import SwiftData

@main
struct PushlyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.accent)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: WorkoutSession.self)
    }
}
