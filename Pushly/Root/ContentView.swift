//
//  ContentView.swift
//  Pushly
//
//  Created by Никита Сторчай on 22.02.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    private enum AppTab: Hashable {
        case home
        case history
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView {
                selectedTab = .history
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(AppTab.home)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(AppTab.history)
        }
        .tint(Color.primary)
    }
}

#Preview {
    ContentView()
}
