//
//  PromptViewModel.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//
import SwiftUI
import Foundation

@MainActor
class PromptViewModel: ObservableObject {
    @Published var currentPrompt: Prompt
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        // Start with a sample prompt until we fetch from server
        self.currentPrompt = Prompt.samplePrompts[0]
        Task {
            await fetchTodaysPrompt()
        }
    }
    
    func fetchTodaysPrompt() async {
        isLoading = true
        errorMessage = nil
        
        do {
            currentPrompt = try await NetworkManager.shared.fetchDailyPrompt()
        } catch {
            errorMessage = "Failed to load today's prompt: \(error.localizedDescription)"
            print("Error fetching daily prompt: \(error)")
        }
        
        isLoading = false
    }
    
    func fetchRandomPrompt() async -> Prompt? {
        do {
            return try await NetworkManager.shared.fetchRandomPrompt()
        } catch {
            print("Error fetching random prompt: \(error)")
            return nil
        }
    }
}
