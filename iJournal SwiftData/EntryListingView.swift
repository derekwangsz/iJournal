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
        List {
            ForEach(entries) { entry in
                HStack {
                    if let data = entry.images.first {
                        if let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(20)
                                .frame(maxHeight: 80)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(entry.title)
                            .font(.headline)
                            .fontDesign(.serif)
                        Text("\(entry.getMood()) \( entry.date.formatted(date:.abbreviated, time: .omitted))")
                            .font(.caption)
                    }
                }
                .onTapGesture {
                    // transition to EntryView
                }
            }
            .onDelete(perform: { indexSet in
                // delete entry
            })
        }
        .listStyle(.plain)
        .scrollIndicators(.automatic)
    }
}

#Preview {
    EntryListingView(searchText: "", sort: SortDescriptor(\Entry.happinessIndex, order: .reverse))
        .modelContainer(Entry.preview)
}
