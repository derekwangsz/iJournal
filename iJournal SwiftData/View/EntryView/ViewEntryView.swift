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
    @State private var finishedLoading = false
    
    var body: some View {
        if finishedLoading {
            ScrollView {
                Text(entry.title)
                    .font(.largeTitle)
                
                VStack {
                    ForEach(Array(stride(from: 0, to: images.count, by: 2)), id: \.self) { i in
                        HStack {
                            images[i]
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(20)
                            
                            if i + 1 < images.count {
                                images[i + 1]
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    
                }
                
                Text("Your mood was a \(Int(entry.happinessIndex)) out of 10!")
                
                Text(entry.text)
                
            }
            .padding(.horizontal)
            
        } else {
            VStack {
                Spacer()
                ProgressView()
                    .task {
                        await loadImages()
                    }
                Spacer()
            }
            
        }
        
        
    }
    
    func loadImages() async {
        images = entry.images.map { data in
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
            } else {
                Image("ramen")
            }
        }
        withAnimation(.easeInOut) {
            finishedLoading = true
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
