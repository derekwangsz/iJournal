//
//  ContentView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-16.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query private var entries: [Entry]
    
    var body: some View {
        List {
            ForEach(entries) { entry in
                Text(entry.title)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(Entry.preview)
}
