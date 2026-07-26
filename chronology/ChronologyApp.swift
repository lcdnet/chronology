//
//  finalprojectlevidanielApp.swift
//  finalprojectlevidaniel
//
//  Created by Levi Daniel on 7/25/26.
//

import SwiftUI
import SwiftData

@main
struct ChronologyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: JournalEntry.self)
    }
}
