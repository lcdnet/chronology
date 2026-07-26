//
//  ContentView.swift
//  finalprojectlevidaniel
//
//  Created by Levi Daniel on 7/25/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            JournalListView()
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
