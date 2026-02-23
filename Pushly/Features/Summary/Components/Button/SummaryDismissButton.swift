//
//  SummaryDismissButton.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct SummaryDismissButton: View {
    let onDismissTapped: () -> Void
    var body: some View {
        Button {
            onDismissTapped()
        } label: {
            Text("Done")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(.accent, in: .rect(cornerRadius: 14))
        }
    }
}

#Preview {
    SummaryDismissButton {
        //
    }
}
