//
//  AppBackgroundView.swift
//  Pushly
//
//  Created by Никита Сторчай on 06.04.2026.
//

import SwiftUI


struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.05, blue: 0.09),
                    Color(red: 0.07, green: 0.04, blue: 0.09),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.accent.opacity(0.20))
                .frame(width: 260, height: 260)
                .blur(radius: 55)
                .offset(x: 130, y: -230)
        }
    }
}

#Preview {
    AppBackgroundView()
}
