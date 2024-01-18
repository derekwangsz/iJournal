//
//  EntryView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-17.
//

import SwiftUI
import SwiftData

struct EntryView: View {
    
    var entry: Entry
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    do {
        // To use example data for the preview, we need to establish our own temporary model container in memory that stores our example data and use that in the preview.
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Entry.self, configurations: config)
        
        let data = UIImage(named: "ramen")!.jpegData(compressionQuality: 1)!
        let example = Entry(images: [data], happinessIndex: 8, date: Date.now, title: "Brilliant day in Tokyo!", text: "I just had the best ramen in my life!")
        return EntryView(entry: example)
            .modelContainer(container)
    }
    catch {
        fatalError("Failed to create model.")
    }
}
