//
//  ContentView.swift
//  SimpleWidgetSuggestions
//
//  Created by Wataru Suzuki on 2021/06/07.
//

import SwiftUI
import HelloSuggestionExtension
import Intents

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                donateRelevantSuggestion()
                donateInteraction()
            }
    }

    private func donateInteraction() {
        let intent = ConfigurationIntent()
        intent.suggestedInvocationPhrase = "(・∀・)"
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func donateRelevantSuggestion() {
        var relevantShortcuts: [INRelevantShortcut] = []

        let intent = ConfigurationIntent()
        intent.suggestedInvocationPhrase = "(・∀・)"

        if let shortcut = INShortcut(intent: intent) {
            let relevantShortcut = INRelevantShortcut(shortcut: shortcut)
            relevantShortcut.shortcutRole = .information
            relevantShortcut.widgetKind = "HelloSuggestion"
            
            let dateProvider = INDateRelevanceProvider(start: Date(),
                                                       end: Date(timeIntervalSinceNow: 1800))
            relevantShortcut.relevanceProviders = [dateProvider]
            
            relevantShortcuts.append(relevantShortcut)
        }

        INRelevantShortcutStore.default.setRelevantShortcuts(relevantShortcuts) { (error) in
            if let error = error {
                print("Failed to set relevant shortcuts. \(error))")
            } else {
                print("Relevant shortcuts set.")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
