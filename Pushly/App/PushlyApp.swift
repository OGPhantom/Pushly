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
    init() {
        ensureApplicationSupportDirectoryExists()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.accent)
        }
        .modelContainer(for: WorkoutSession.self) 
    }

    private func ensureApplicationSupportDirectoryExists() {
        do {
            _ = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        } catch {
            assertionFailure("Failed to create Application Support directory: \(error)")
        }
    }
}
