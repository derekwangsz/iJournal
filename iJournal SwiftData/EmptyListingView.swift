//
//  EmptyListingView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-25.
//

import SwiftUI

struct EmptyListingView: View {
    var body: some View {
        
        VStack {
            Spacer()
            Image("chicken")
                .resizable()
                .scaledToFit()
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                .frame(maxWidth: 259)
            
            Text("You have no journals\nCreate a journal to get started!")
                .fontDesign(.serif)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
                
            Spacer()
        }
        .offset(y: -50)
    }
}

#Preview {
    EmptyListingView()
}
