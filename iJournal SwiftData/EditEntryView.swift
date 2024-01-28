//
//  EditEntryView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-16.
//

import SwiftUI
import SwiftData
import PhotosUI
import UIKit


struct EditEntryView: View {
    @State private var selectedItems = [PhotosPickerItem]()
    
    @State private var selectedImages = [Image]()
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var typing : Bool
    
    @Bindable var entry: Entry
    
    var body: some View {
        
        Form {
            Section("Title") {
                TextField("Title", text: $entry.title, prompt: Text("Title..."))
                    .font(.title)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            Section("Images") {
                PhotosPicker(selection: $selectedItems, matching: .images) {
                    HStack {
                        Circle()
                            .opacity(0.5)
                            .overlay {
                                Image(systemName: "plus")
                                    .resizable()
                                    .padding()
                            }
                            .frame(width: 50, height: 50)
                        
                        Text("Add Image")
                            .font(.title)
                            .fontWeight(.bold)
                        
                    }
                }
                .onChange(of: selectedItems) {
                    Task {
                        await fetchImages()
                    }
                }
                
                LazyVGrid (columns: [GridItem(.flexible()),
                                     GridItem(.flexible()),
                                     GridItem(.flexible())], alignment: .leading, spacing: 10) {
                    ForEach(0..<selectedImages.count, id: \.self) { i in
                        selectedImages[i]
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                        
                    }
                }
            }
            
            Section("How are you feeling?") {
                VStack {
                    Text("Your mood...")
                        .font(.title3)
                        .fontDesign(.serif)
                    Slider(value: $entry.happinessIndex,
                           in: 0...10, step: 1,
                           label: { Text("\(Int(entry.happinessIndex))") },
                           minimumValueLabel:
                            { Text("🤮").font(.title)},
                           maximumValueLabel:
                            {Text("🚀").font(.title)})
                }
            }
            
            
            Section("Write down your throughts") {
                TextEditor(text: $entry.text)
                    .focused($typing)
            }
        }
        .onAppear {
            loadImages()
        }
        
    }
    
    func fetchImages() async {
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self) {
                entry.images.insert(data, at: 0)
                
                guard let uiImage = UIImage(data: data) else { return }
                withAnimation(.easeInOut) {
                    selectedImages.insert(Image(uiImage: uiImage), at: 0)
                }
            }
        }
    }
    
    func loadImages() {
        withAnimation(.easeInOut) {
            selectedImages = entry.images.map { data in
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
        return EditEntryView(entry: example)
            .modelContainer(container)
    }
    catch {
        fatalError("Failed to create model.")
    }
}

