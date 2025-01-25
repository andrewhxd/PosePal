//
//  Prompt.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import Foundation

struct Prompt: Identifiable {
    let id = UUID()
    let title: String
    let details: String
    let date: Date
    
    // Static sample data
    static let samplePrompts: [Prompt] = [
        Prompt(title: "Prompt 1", details: "Details for prompt 1", date: Date()),
        Prompt(title: "Prompt 2", details: "Details for prompt 2", date: Date().addingTimeInterval(-86400)), // Yesterday
        Prompt(title: "Prompt 3", details: "Details for prompt 3", date: Date().addingTimeInterval(86400)) // Tomorrow
    ]
    
    // Static method to get a random prompt
    static func getRandomPrompt() -> Prompt? {
        return samplePrompts.randomElement()
    }
}
