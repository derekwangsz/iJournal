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
                    ForEach(entries) { entry in
                        NavigationLink(value: entry) {
                            EntryListingCellView(entry: entry)
                        }
                        .buttonStyle(ListButtonStyle())
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                .opacity(phase.isIdentity ? 1 : 0.3)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        delete(indexSet)
                    })
                }
            }
            .navigationDestination(for: Entry.self) { entry in
                EntryView(entry: entry)
            }
            .toolbar(.hidden, for: .navigationBar)
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
