//
//  Entry.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-16.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Entry {
    var images: [Data]
    var happinessIndex: Double
    var date: Date
    var title: String
    var text: String
    
    init(images: [Data], happinessIndex: Double, date: Date, title: String, text: String) {
        self.images = images
        self.happinessIndex = happinessIndex
        self.date = date
        self.title = title
        self.text = text
    }
    
    init() {
        self.images = []
        self.happinessIndex = 3
        self.date = .now
        self.title = ""
        self.text = ""
    }
    
    func getMood() -> String {
        switch happinessIndex {
        case 0..<3:
            return "🤮"
        case 3..<6:
            return "🙁"
        case 6..<8:
            return "😁"
        case 8...10:
            return "🚀"
        default:
            return "😳"
        }
    }
}


extension Entry {
    // Create a static property that returns a ModelContainer
        @MainActor
        static var preview: ModelContainer {
            let container = try! ModelContainer(for: Entry.self,
                                                configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            let data = UIImage(named: "ramen")!.jpegData(compressionQuality: 1)!
            
            container.mainContext.insert(Entry(images: [data], happinessIndex: 0, date: .now, title: "First day in Tokyo", text: "Ate first ramen!"))
            container.mainContext.insert(Entry(images: [data], happinessIndex: 2, date: .now, title: "Second day in Tokyo", text: "Ate second ramen!"))
            container.mainContext.insert(Entry(images: [data], happinessIndex: 4, date: .now, title: "Third day in Tokyo", text: "Ate third ramen!"))
            container.mainContext.insert(Entry(images: [data], happinessIndex: 6, date: .now, title: "Fourth day in Tokyo", text: "Ate fourth ramen!"))
            container.mainContext.insert(Entry(images: [data], happinessIndex: 8, date: .now, title: "Fifth day in Tokyo", text: "Ate fifth ramen!"))
            container.mainContext.insert(Entry(images: [data], happinessIndex: 10, date: .now, title: "Sixth day in Tokyo", text: "Ate sixth ramen!"))
            
            return container
        }
}
