//
//  Prompt.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import Foundation

struct PromptResponse: Codable {
    let prompt: String
    
    // Custom coding keys to match API response
    enum CodingKeys: String, CodingKey {
        case prompt = "prompt"
    }
}
struct Prompt: Identifiable {
    let id = UUID()
    let title: String
    let details: String
    let date: Date
    
    static let samplePrompts: [Prompt] = [
            Prompt(title: "Fall Back: Prompt 1", details: "Details for prompt 1", date: Date()),
            Prompt(title: "Fall Back: Prompt 2", details: "Details for prompt 2", date: Date().addingTimeInterval(-86400)), // Yesterday
            Prompt(title: "Fall Back: Prompt 3", details: "Details for prompt 3", date: Date().addingTimeInterval(86400)) // Tomorrow
        ]
    // Static method to get a random prompt
    static func getRandomPrompt() -> Prompt? {
        return samplePrompts.randomElement()
    }
    
    static func fromResponse(_ response: PromptResponse) -> Prompt {
            return Prompt(
                title: response.prompt,
                details: "",
                date: Date() // Use current date since API doesn't provide one
            )
        }
}
