//
//  AddEntryViewModel.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2025-02-17.
//

import SwiftData
import SwiftUI
import PhotosUI


@Observable
class AddEntryViewModel {
    private var modelContext: ModelContext
    
    var selectedItems = [PhotosPickerItem]()
    var selectedImages = [Image]()
    
    var title = ""
    var date = Date.now
    var mood = 7.0
    var imageData: [Data] = []
    var text = ""
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
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
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            title = Date.now.formatted(date: .abbreviated, time: .omitted)
        }
        let newEntry = Entry(images: imageData, happinessIndex: mood, date: .now, title: title, text: text)
        modelContext.insert(newEntry)
    }
}

