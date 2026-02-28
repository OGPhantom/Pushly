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
        Picker("Period", selection: $selectedPeriod) {
            ForEach(HistoryViewModel.TimePeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    HistoryPeriodPicker(selectedPeriod: .constant(.all))
}
