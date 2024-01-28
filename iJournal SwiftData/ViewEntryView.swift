//
//  ViewEntryView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-27.
//

import SwiftUI
import SwiftData
import UIKit

struct ViewEntryView: View {
    
    var entry: Entry
    
    @State private var images: [Image] = []
    
    var body: some View {
        ScrollView {
            Text(entry.title)
                .font(.largeTitle)
            
            LazyVGrid(columns: [GridItem(.flexible()),
                                GridItem(.flexible())]) {
                ForEach(0..<images.count, id: \.self) { i in
                    images[i]
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                }
            }
            
            Text("Your mood was a \(Int(entry.happinessIndex)) out of 10!")
            
            Text(entry.text)
            
        }
        .padding(.horizontal)
        .onAppear {
            loadImages()
        }
    }
    
    func loadImages() {
        withAnimation(.easeInOut) {
            images = entry.images.map { data in
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                } else {
                    Image("ramen")
                }
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
        return ViewEntryView(entry: example)
            .modelContainer(container)
    }
    catch {
        fatalError("Failed to create model.")
    }
}
