//
//  SummaryHeader.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SummaryHeader: View {
    let date: Date
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)
                .symbolEffect(.bounce, value: true)

            Text("Workout Complete!")
                .font(.title.bold())

            Text(date.formatted(date: .abbreviated, time: .shortened))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    SummaryHeader(date: .now)
}
