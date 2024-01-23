//
//  EntryListingCellView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-23.
//

import SwiftUI
import SwiftData

struct EntryListingCellView: View {
    
    var entry : Entry
    
    var body: some View {
        HStack {
            if let data = entry.images.first {
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(maxHeight: 80)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(entry.title)
                    .font(.headline)
                    .fontDesign(.serif)
                Text("\(entry.getMood()) \( entry.date.formatted(date:.abbreviated, time: .omitted))")
                    .font(.caption)
            }
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
        return EntryListingCellView(entry: example)
            .modelContainer(container)
    }
    catch {
        fatalError("Failed to create model.")
    }
}
