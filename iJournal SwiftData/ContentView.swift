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
    
    @State private var searchText = ""
    
    @State private var sortDescriptor: SortDescriptor<Entry> = SortDescriptor(\Entry.date, order: .reverse)
    
    @State private var presentSheet = false
    
    
    var body: some View {
        
        VStack {
            HStack {
                // Menu for sort order selection
                Menu {
                    Button {
                        withAnimation {
                            sortDescriptor = SortDescriptor(\Entry.date, order: .reverse)
                        }
                    } label: {
                        Label("Date", systemImage: "clock")
                    }
                    
                    Button {
                        withAnimation {
                            sortDescriptor = SortDescriptor(\Entry.title)
                        }
                    } label: {
                        Label("Title", systemImage: "textformat.alt")
                    }
                    
                    Button {
                        withAnimation {
                            sortDescriptor = SortDescriptor(\Entry.happinessIndex, order: .reverse)
                        }
                    } label: {
                        Label("Mood", systemImage: "face.smiling")
                    }
                    
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                }
                
                Spacer()
                
                Text("iJournal")
                    .font(.system(size: 42))
                    .fontDesign(.rounded)
                    .fontWeight(.thin)
                    .padding()
                
                Spacer()
                
                Button {
                    // construct new Entry & transition to EditEntryView
                    presentSheet = true
                    
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            TextField("Search...", text: $searchText)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(.quaternary)
                .cornerRadius(30)
                .padding(.horizontal)
                .font(.title3)
                .fontWeight(.thin)
                .fontDesign(.serif)
            
            Divider()
            
            EntryListingView(searchText: searchText, sort: sortDescriptor)
        }
        .sheet(isPresented: $presentSheet) {
            AddEntryView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(Entry.preview)
}
