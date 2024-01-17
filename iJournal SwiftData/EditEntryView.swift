//
//  EditEntryView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-16.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditEntryView: View {
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    @FocusState private var typing : Bool
    
    @Bindable var entry: Entry
    
    var body: some View {
        VStack {
            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
            
            Form {
                PhotosPicker(selection: $selectedItems, matching: .images) {
                    HStack {
                        Circle()
                            .opacity(0.5)
                            .overlay {
                                Image(systemName: "plus")
                                    .resizable()
                                    .padding()
                            }
                            .frame(width: 80, height: 80)
                        
                        Text("Add Image")
                            .font(.title)
                            .fontWeight(.bold)
                        
                    }
                }
                .onChange(of: selectedItems) {
                    Task {
                        selectedImages.removeAll()
                        
                        for item in selectedItems {
                            if let image = try? await item.loadTransferable(type: Image.self) {
                                selectedImages.append(image)
                            }
                        }
                    }
                }
                
                Section("How are you feeling?") {
                    VStack {
                        Text("Your mood...")
                            .font(.title3)
                            .fontDesign(.serif)
                        Slider(value: $entry.happinessIndex,
                               in: 0...11, step: 1,
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
        }
        
        
    }
}

#Preview {
    do {
        // To use example data for the preview, we need to establish our own temporary model container in memory that stores our example data and use that in the preview.
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Entry.self, configurations: config)
        let example = Entry(images: [], happinessIndex: 8, date: Date.now, text: "What happened today? ...")
        return EditEntryView(entry: example)
            .modelContainer(container)
    }
    catch {
        fatalError("Failed to create model.")
    }
}
