//
//  ContentView.swift
//  iJournal SwiftData
//
//  Created by Derek Wang on 2024-01-16.
//

import SwiftUI
import SwiftData
import UIKit
import LocalAuthentication
import LocalAuthenticationEmbeddedUI

struct ContentView: View {
    
    @State private var isAuthenticated = false
    
    var body: some View {
        if isAuthenticated {
            HomeView()
        } else {
            Spacer()
                .onAppear {
                    authenticate()
                }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reasonString = "We need to unlock your journals..."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, error in
                if success {
                    withAnimation {
                        isAuthenticated = true
                    }
                } else {
                    // authentication failed
                }
            }
        } else {
            withAnimation {
                isAuthenticated = true
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(Entry.preview)
}
