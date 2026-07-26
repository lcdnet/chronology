//
//  EntryDetailView.swift
//  finalprojectlevidaniel
//
//  Created by Levi Daniel on 7/25/26.
//

import SwiftUI
import SwiftData

// Shows everything about an entry.
struct EntryDetailView: View {
    @Bindable var entry: JournalEntry
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    // Mood
                    Text(entry.mood)
                        .font(.largeTitle)
                    
                    // Category & Date
                    VStack(alignment:.leading) {
                        Text(entry.category)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal,8)
                            .padding(.vertical,4)
                            .background(Color.accentColor.opacity(0.15))
                            .foregroundColor(.accentColor)
                            .clipShape(Capsule())
                        
                        Text(entry.date.formatted(date:.long,time:.shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Favorite Toggle Button
                    Button(action: {entry.isFavorite.toggle()}) {
                        Image(systemName: entry.isFavorite ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundColor(entry.isFavorite ? .yellow : .gray)
                    }
                }
                
                Divider()
                
                Text(entry.content)
                    .font(.body)
                    .lineSpacing(6)
                
                if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .padding(.top,8)
                    
                }
            }
            .padding()
        }
        .navigationTitle(entry.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: JournalEntry.self, configurations: config)

    let sampleEntry = JournalEntry(
        title: "Reflections on SwiftData",
        content: "Using `@Model` and `@Query` makes setting up persistence noticeably cleaner than old CoreData stack setups. Everything updates really seamlessly.",
        date: Date(),
        mood: "Happy",
        category: "Ideas",
        isFavorite: false
    )

    container.mainContext.insert(sampleEntry)

    return NavigationStack {
        EntryDetailView(entry: sampleEntry)
    }
    .modelContainer(container)
}
