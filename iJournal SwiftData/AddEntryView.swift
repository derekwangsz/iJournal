//
//  AddEntryView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-21.
//

import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct AddEntryView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var typing : Bool
    
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    @State private var title = ""
    @State private var date = Date.now
    @State private var mood = 3.0
    @State private var imageData: [Data] = []
    @State private var text = ""
    
    var body: some View {
        VStack {
            HStack {
                
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Text(date.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline.bold())
                
                Spacer()
                
                Button("Save") {
                    save()
                    dismiss()
                }
                .font(.headline)
                
            }
            .padding(25)
            
            Form {
                Section("Title") {
                    TextField("Title", text: $title, prompt: Text("Title..."))
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
                        Slider(value: $mood,
                               in: 0...10, step: 1,
                               label: { Text("\(Int(mood))") },
                               minimumValueLabel:
                                { Text("🤮").font(.title)},
                               maximumValueLabel:
                                {Text("🚀").font(.title)})
                    }
                }
                
                
                Section("Write down your throughts") {
                    TextEditor(text: $text)
                        .focused($typing)
                }
            }
        }
    }
    
    func fetchImages() async {
        for item in selectedItems {
            if let data = try? await item.loadTransferable(type: Data.self) {
                imageData.insert(data, at: 0)
                
                guard let uiImage = UIImage(data: data) else { return }
                withAnimation(.easeInOut) {
                    selectedImages.insert(Image(uiImage: uiImage), at: 0)
                }
            }
        }
    }
    
    func save() {
        let newEntry = Entry(images: imageData, happinessIndex: mood, date: .now, title: title, text: text)
        modelContext.insert(newEntry)
    }
    
}

#Preview {
    AddEntryView()
}
