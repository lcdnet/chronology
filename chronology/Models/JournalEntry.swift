//
//  JournalEntry.swift
//  finalprojectlevidaniel
//
//  Created by Levi Daniel on 7/25/26.
//

import Foundation
import SwiftData

// Resuable Model Component, this holds the data for each entry.
@Model
final class JournalEntry {
    var id: UUID
    var title: String
    var content: String
    var date: Date
    var mood: String
    var category: String
    var isFavorite: Bool
    @Attribute(.externalStorage) var photoData: Data?
    
    init(
        title: String,
        content: String,
        date: Date = Date(),
        mood: String = "Calm",
        category: String = "Personal",
        isFavorite: Bool = false,
        photoData: Data? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.date = date
        self.mood = mood
        self.category = category
        self.isFavorite = isFavorite
        self.photoData = photoData
    }
}
