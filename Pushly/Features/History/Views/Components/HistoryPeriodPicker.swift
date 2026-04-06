//
//  HistoryPeriodPicker.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct HistoryPeriodPicker: View {
    @Binding var selectedPeriod: HistoryViewModel.TimePeriod

    var body: some View {
        HStack(spacing: 10) {
            ForEach(HistoryViewModel.TimePeriod.allCases, id: \.self) { period in
                Button {
                    withAnimation(.snappy(duration: 0.24)) {
                        selectedPeriod = period
                    }
                } label: {
                    Text(period.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(selectedPeriod == period ? Color.black : Color.white.opacity(0.72))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(background(for: period))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private extension HistoryPeriodPicker {
    @ViewBuilder
    func background(for period: HistoryViewModel.TimePeriod) -> some View {
        if selectedPeriod == period {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [.white, Color.white.opacity(0.76)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        } else {
            Capsule()
                .fill(.white.opacity(0.06))
                .overlay(
                    Capsule()
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )
        }
    }
}

#Preview {
    HistoryPeriodPicker(selectedPeriod: .constant(.all))
}
