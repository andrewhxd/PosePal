//
//  PromptViewModel.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//
import SwiftUI
import Foundation

class PromptViewModel: ObservableObject {
    @Published var currentPrompt: Prompt
    
    init() {
        currentPrompt = Prompt.samplePrompts[0]
    }
    
    func generateRandomPrompt() {
        if let newPrompt = Prompt.getRandomPrompt() {
            currentPrompt = newPrompt
        }
    }
}
