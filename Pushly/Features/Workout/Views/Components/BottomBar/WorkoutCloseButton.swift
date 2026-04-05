//
//  WorkoutCloseButton.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct WorkoutCloseButton: View {
    let onCloseTapped: () -> Void
    
    var body: some View {
        Button {
            onCloseTapped()
        } label: {
            Image(systemName: "xmark")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(.ultraThinMaterial, in: .circle)
        }
    }
}

#Preview {
    WorkoutCloseButton {
        //
    }
}
