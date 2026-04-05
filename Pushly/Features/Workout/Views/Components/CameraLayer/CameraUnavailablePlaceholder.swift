//
//  CameraUnavailablePlaceholder.swift
//  Pushly
//
//  Created by Никита Сторчай on 23.02.2026.
//

import SwiftUI

struct CameraUnavailablePlaceholder: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.5))

            Text("Camera Unavailable")
                .font(.title2.bold())
                .foregroundStyle(.white)

            Text("The camera preview is only available on a real device")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.darkGray))
    }
}

#Preview {
    CameraUnavailablePlaceholder()
}
