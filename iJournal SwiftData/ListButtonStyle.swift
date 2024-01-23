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
            .shadow(radius: 40)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
