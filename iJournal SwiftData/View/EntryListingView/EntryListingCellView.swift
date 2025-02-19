//
//  EntryListingCellView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-23.
//

import SwiftUI
import SwiftData

struct EntryListingCellView: View {
    
    @Environment(\.modelContext) var modelContext
    @Bindable var entry : Entry
    
    @State private var showModal = false
    
    @State private var scale = 1.0
    @State private var opacity = 1.0
    
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
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(50)
        .shadow(color: Color.secondary, radius: 2, x: 1, y: 4)
        .scaleEffect(scale)
        .opacity(opacity)
        .swipeButtons([
            CustomSwipeButton(image: Image(systemName: "trash.fill"), title: "Delete", color: .red, action: {
                delete()
            })
        ])
        .onTapGesture {
            withAnimation() {
                scale = 1.1
                opacity = 1.1
            }
            
            showModal = true
            
            scale = 1
            opacity = 1
            
        }
        .fullScreenCover(isPresented: $showModal) {
            EntryView(entry: entry)
        }
    }
    
    func delete() {
        withAnimation {
            modelContext.delete(entry)
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
