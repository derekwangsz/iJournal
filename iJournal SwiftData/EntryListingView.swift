//
//  EntryListingView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-18.
//

import SwiftUI
import SwiftData

struct EntryListingView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query private var entries: [Entry]
    
    @State private var presentEntry = false
    
    init(searchText: String, sort: SortDescriptor<Entry>) {
        _entries = Query(
            filter: #Predicate {
                if searchText.isEmpty {
                    return true
                } else {
                    return $0.title.localizedStandardContains(searchText)
                }},
            sort: [sort],
            animation: .easeInOut)
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVStack {
                    //            List {
                    ForEach(entries) { entry in
                        
                        EntryListingCellView(entry: entry)
//                            .buttonStyle(ListButtonStyle())
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                    .opacity(phase.isIdentity ? 1 : 0.3)
                            }
                        
                        //MARK: - SCROLLVIEW doesn't seem to allow swipe actions!
                        // Only List with embedded ForEach allows for swipe.
                    }
                    .onDelete(perform: { indexSet in
                        delete(indexSet)
                    })
                }
                //.listStyle(.plain)
            }
        }
    }
    
    func delete(_ indexSet: IndexSet) {
        for i in indexSet {
            let entry = entries[i]
            modelContext.delete(entry)
        }
    }
}

#Preview {
    EntryListingView(searchText: "", sort: SortDescriptor(\Entry.happinessIndex, order: .reverse))
        .modelContainer(Entry.preview)
}
