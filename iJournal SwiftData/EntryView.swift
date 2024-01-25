//
//  EntryView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-17.
//

import SwiftUI
import SwiftData
import UIKit

struct EntryView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    
    @Bindable var entry: Entry
    
    var body: some View {
        Button(entry.title) {
            dismiss()
        }
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
