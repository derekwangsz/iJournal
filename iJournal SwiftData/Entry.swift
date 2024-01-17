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
    var text: String
    
    init(images: [Data], happinessIndex: Double, date: Date, text: String) {
        self.images = images
        self.happinessIndex = happinessIndex
        self.date = date
        self.text = text
    }
}
