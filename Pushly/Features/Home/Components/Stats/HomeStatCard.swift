//
//  HomeStatCard.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HomeStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.primary)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 14))
    }
}

#Preview {
    HomeStatCard(title: "This Week", value: "10", icon: "flame.fill", color: .orange)
}
