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
        List {
            ForEach(entries) { entry in
                Button {
                    presentEntry = true
                } label: {
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
                }
                .fullScreenCover(isPresented: $presentEntry) {
                    EntryView(entry: entry)
                }
                .buttonStyle(ListButtonStyle())
            }
            .onDelete(perform: { indexSet in
                // delete entry
                delete(indexSet)
            })
        }
        .listStyle(.plain)
        .scrollIndicators(.automatic)
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
