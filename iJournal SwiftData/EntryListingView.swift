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
//                            .padding()
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 20)
//                                    .strokeBorder(lineWidth: 0)
//                                    .shadow(color: .black ,radius: 5, x: 10, y: 10)
//                            }
                        }
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                .opacity(phase.isIdentity ? 1 : 0.2)
                        }
                        .buttonStyle(ListButtonStyle())
                    }
                    .onDelete(perform: { indexSet in
                        // delete entry
                        delete(indexSet)
                    })
                }
                .contentMargins(5, for: .scrollIndicators)
                .scrollIndicators(.automatic)
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
