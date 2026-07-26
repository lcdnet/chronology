//
//  InsightsView.swift
//  finalprojectlevidaniel
//
//  Created by Levi Daniel on 7/25/26.
//

import SwiftUI
import SwiftData


// Show insights of all entries.
struct InsightsView: View {
    @Query private var entries: [JournalEntry]
    
    var totalEntries: Int { entries.count }
    
    // Show number of favorites, filter instead of making a separate array.
    var favoriteCount: Int {entries.filter {$0.isFavorite}.count }
    
    // Show how many entries each mood has.
    var moodBreakdown: [String: Int] {
        Dictionary(grouping: entries, by: { $0.mood })
            .mapValues{$0.count}
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Total & Total Favorites
                Section("Overview") {
                    HStack {
                        Text("Total Entries")
                        Spacer()
                        Text("\(totalEntries)")
                            .bold()
                    }
                    HStack {
                        Text("Starred Entries")
                        Spacer()
                        Text("\(favoriteCount)")
                            .bold()
                    }
                }

                // Number of entries per mood
                Section("Mood Breakdown") {
                    if moodBreakdown.isEmpty {
                        Text("No entries recorded yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(moodBreakdown.keys.sorted(), id: \.self) { mood in
                            HStack {
                                Text(mood)
                                Spacer()
                                Text("\(moodBreakdown[mood] ?? 0)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Insights")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: JournalEntry.self, configurations: config)

    // Pre-populate data to verify total calculations in canvas
    let entries = [
        JournalEntry(title: "Entry 1", content: "", mood: "Happy", category: "Personal", isFavorite: true),
        JournalEntry(title: "Entry 2", content: "", mood: "Calm", category: "Personal"),
        JournalEntry(title: "Entry 3", content: "", mood: "Happy", category: "Ideas", isFavorite: true),
        JournalEntry(title: "Entry 4", content: "", mood: "Energetic", category: "Study")
    ]

    for entry in entries {
        container.mainContext.insert(entry)
    }

    return InsightsView()
        .modelContainer(container)
}
