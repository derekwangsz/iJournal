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
    
    @State private var viewModel: AddEntryViewModel
    
    init(modelContext: ModelContext) {
        let viewModel = AddEntryViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Text(viewModel.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline.bold())
                
                Spacer()
                
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
                .font(.headline)
                
            }
            .padding(25)
            
            Form {
                Section("Title") {
                    TextField("Title", text: $viewModel.title, prompt: Text("Title..."))
                        .font(.title)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Section("Images") {
                    PhotosPicker(selection: $viewModel.selectedItems, matching: .images) {
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
                    .onChange(of: viewModel.selectedItems) {
                        Task {
                            await viewModel.fetchImages()
                        }
                    }
                    
                    LazyVGrid (columns: [GridItem(.flexible()),
                                         GridItem(.flexible()),
                                         GridItem(.flexible())], alignment: .leading, spacing: 10) {
                        ForEach(0..<viewModel.selectedImages.count, id: \.self) { i in
                            viewModel.selectedImages[i]
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
                        Slider(value: $viewModel.mood,
                               in: 0...10, step: 1,
                               label: { Text("\(Int(viewModel.mood))") },
                               minimumValueLabel:
                                { Text("🤮").font(.title)},
                               maximumValueLabel:
                                {Text("🚀").font(.title)})
                    }
                }
                
                
                Section("Write down your throughts") {
                    TextEditor(text: $viewModel.text)
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
        
        return AddEntryView(modelContext: container.mainContext)
    } catch {
        fatalError("Failed to make model")
    }
    
}
