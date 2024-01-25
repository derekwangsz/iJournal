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
    @State private var showDialog = false
    
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
        
        if entries.isEmpty {
            EmptyListingView()
        } else {
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(entries) { entry in
                            EntryListingCellView(entry: entry)
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                        .opacity(phase.isIdentity ? 1 : 0.3)
                                }
                                .swipeButtons([
                                    CustomSwipeButton(image: Image(systemName: "trash.fill"), title: "Delete", color: .red, action: {
                                        //MARK: - For some reason when we use confirmationDialog sometimes the wrong entry is selected...
                                        // showDialog = true
                                        delete(entry: entry)
                                    })
                                ])
                                .confirmationDialog("Delete \"\(entry.title)\"?", isPresented: $showDialog, titleVisibility: .visible) {
                                    Button("Yes", role: .destructive) {
                                        delete(entry: entry)
                                    }
                                }
                        }
                    }
                }
            }
        }
        
    }
    
    func delete(entry: Entry) {
        modelContext.delete(entry)
    }
}

#Preview {
    EntryListingView(searchText: "", sort: SortDescriptor(\Entry.happinessIndex, order: .reverse))
        .modelContainer(Entry.preview)
}
