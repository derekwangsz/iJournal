//
//  ListButtonStyle.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-21.
//

import Foundation
import SwiftUI

struct ListButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(50)
            .shadow(color: Color.secondary, radius: 2, x: 1, y: 4)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
