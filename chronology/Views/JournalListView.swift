//
//  JournalListView.swift
//  finalprojectlevidaniel
//
//  Created by Levi Daniel on 7/25/26.
//

import SwiftUI
import SwiftData

struct JournalListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showNewEntrySheet = false
    
    let categories = ["All", "Favorites", "Personal", "Study", "Ideas", "Health"]
    
    var filteredEntries: [JournalEntry] {
        entries.filter { entry in
            let matchesCategory = (selectedCategory == "All") ? true : (selectedCategory == "Favorites" ? entry.isFavorite : entry.category == selectedCategory)
            
            let matchesSearch = searchText.isEmpty || entry.title.localizedCaseInsensitiveContains(searchText) || entry.content.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Filter bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { cat in
                            Button(action: {selectedCategory = cat}) {
                                Text(cat)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == cat ? Color.accentColor : Color(.secondarySystemBackground))
                                    .foregroundColor(selectedCategory == cat ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 6)
                
                // List or Empty State
                if filteredEntries.isEmpty {
                    ContentUnavailableView("No Entries Found", systemImage: "square.and.pencil", description: Text("Tap '+' to start writing your first reflection."))
                } else {
                    List {
                        ForEach(filteredEntries) { entry in
                            NavigationLink(destination: EntryDetailView(entry: entry)) {
                                JournalRowView(entry: entry)
                            }
                        }
                        .onDelete(perform: deleteEntries)
                    }
                    .listStyle(.plain)
                }
                
            }
            .navigationTitle("Chronology")
            .searchable(text: $searchText, prompt: "Search Entries...")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {showNewEntrySheet = true}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showNewEntrySheet) {
                NewEntryView()
            }
        }
    }
    
    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredEntries[index])
        }
    }
    
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: JournalEntry.self, configurations: config)
    
    // 2 Samples
    let sample1 = JournalEntry(
        title: "Morning Walk",
        content: "Saw a great sunrise down by the lake today. Feeling energized for the week.",
        mood: "Energetic",
        category: "Personal",
        isFavorite: true
    )
    let sample2 = JournalEntry(
        title: "SwiftUI Architecture Ideas",
        content: "Drafted out the view model layer for the new mobile assignment.",
        mood: "Thoughtful",
        category: "Study"
    )
    
    container.mainContext.insert(sample1)
    container.mainContext.insert(sample2)
    
    return JournalListView()
        .modelContainer(container)
    
}
