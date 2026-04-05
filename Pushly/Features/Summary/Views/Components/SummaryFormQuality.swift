//
//  SummaryFormQuality.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SummaryFormQuality: View {
    let formScore: Double

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Form Quality")
                    .font(.headline)
                Spacer()
                Text("\(Int(formScore * 100))%")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(.accent)
                        .frame(width: geo.size.width * formScore, height: 12)
                }
            }
            .frame(height: 12)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 14))
    }
}

#Preview {
    SummaryFormQuality(formScore: 0.89)
}
