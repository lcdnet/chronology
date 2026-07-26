//
//  JournalRowView.swift
//  finalprojectlevidaniel
//
//  Created by Levi Daniel on 7/25/26.
//

import SwiftUI

struct JournalRowView: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack(spacing: 12) {
            Text(entry.mood)
                .font(.title2)
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.title)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    if entry.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
                
                Text(entry.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(Color(.tertiarySystemFill))
            }
        }
        .padding(.vertical, 4)
        
    }
}

#Preview("Standard Row") {
    let sampleEntry = JournalEntry(
        title: "Campus Study Session",
        content: "Finished up the Software Construction prep early. Great focus today.",
        date: Date(),
        mood: "Calm",
        category: "Study",
        isFavorite: true
    )
    
    return JournalRowView(entry:sampleEntry)
        .padding()
}
