//
//  iJournal_SwiftDataApp.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-16.
//

import SwiftUI
import SwiftData

@main
struct iJournal_SwiftDataApp: App {
    
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Entry.self)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Entry.self)
        } catch {
            fatalError("Failed to create ModelContainer for Entry")
        }
    }
}
