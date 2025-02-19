//
//  HomeView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-02-27.
//

import SwiftUI
import SwiftData
import UIKit

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var isAuthenticated = false
    
    @State private var searchText = ""
    
    @State private var sortDescriptor: SortDescriptor<Entry> = SortDescriptor(\Entry.date, order: .reverse)
    
    @State private var presentSheet = false
    
    
    var body: some View {
        
        VStack {
            HStack {
                // Menu for sort order selection
                //MARK: - Show which filter is being applied in the menu (maybe with a checkmark?)
                // Can we figure out a way of putting the buttons in a selector while maintaining animation functionality?
                
                //MARK: - SOLVED!!! add .animation modifier to EntryListingView based on sortDescriptor state.
                
                Menu {
                    Picker("Sort Descriptor", selection: $sortDescriptor) {
                        Label(" Date", systemImage: "clock")
                            .tag(SortDescriptor(\Entry.date, order: .reverse))
                        
                        
                        Label(" Title", systemImage: "textformat.alt")
                            .tag(SortDescriptor(\Entry.title))
                        
                        
                        Label(" Mood", systemImage: "face.smiling")
                            .tag(SortDescriptor(\Entry.happinessIndex, order: .reverse))
                        
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
                .animation(.easeInOut, value: sortDescriptor)
        }
        .sheet(isPresented: $presentSheet) {
            AddEntryView(modelContext: modelContext)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(Entry.preview)
}
