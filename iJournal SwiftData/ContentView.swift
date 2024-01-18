//
//  ContentView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-16.
//

import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query private var entries: [Entry]
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    // show menu of filtering options
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                }
                
                Spacer()
                
                Text("iJournal")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .fontWeight(.thin)
                    .padding()
                
                Spacer()
                
                Button {
                    // construct new Entry & transition to EditEntryView
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
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
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                        }
                    }
                    .onTapGesture {
                        // transition to EntryView
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.automatic)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(Entry.preview)
}
