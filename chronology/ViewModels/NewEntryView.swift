//
//  NewEntryView.swift
//  finalprojectlevidaniel
//
//  Created by Levi Daniel on 7/25/26.
//

import SwiftUI
import SwiftData
import PhotosUI

// View when making a new entry
struct NewEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var category = "Personal"
    @State private var mood = "Calm"
    @State private var selectedPhotoItem: PhotosPickerItem? // User can pick a photo
    @State private var selectedImageData: Data?
    
    let categories = ["Personal", "Study", "Ideas", "Health"]
    let moods = ["Calm", "Happy", "Sad", "Energetic", "Thoughtful", "Angry"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Header") {
                    TextField("Entry Title", text: $title)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) {Text($0)}
                    }
                    
                    Picker("Mood", selection: $mood) {
                        ForEach(moods, id: \.self) {Text($0)}
                    }
                }
                
                Section("Reflection") {
                    TextEditor(text: $content)
                        .frame(minHeight:150)
                }
                
                Section("Attachment") {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Select Photo", systemImage: "photo")
                    }
                    
                    // Displays image in a preview frame
                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight:200)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // The Two Buttons On Top Left & Right
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {dismiss()}
                }
                
                ToolbarItem(placement:.confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = true ? data : nil
                    }
                }
            }
        }
    }
    
    private func saveEntry() {
        let newEntry = JournalEntry(
            title: title,
            content: content,
            date: Date(),
            mood: mood,
            category: category,
            photoData: selectedImageData
        )
        modelContext.insert(newEntry)
        dismiss()
    }
}

#Preview {
    NewEntryView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
