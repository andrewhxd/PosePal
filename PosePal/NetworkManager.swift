//
//  NetworkManager.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://posepalbackend.onrender.com"
    
    func fetchDailyPrompt() async throws -> Prompt {
        guard let url = URL(string: "\(baseURL)/prompt/daily") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let response = try JSONDecoder().decode(DailyPromptResponse.self, from: data)
            return Prompt(title: response.prompt, details: "", date: Date())
        } catch {
            print("Decoding error: \(error)")
            return Prompt.samplePrompts[0]
        }
    }
    
    func fetchRandomPrompt() async throws -> Prompt {
        guard let url = URL(string: "\(baseURL)/prompt/random") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let response = try JSONDecoder().decode(RandomPromptResponse.self, from: data)
            return Prompt(title: response.random_prompt, details: "", date: Date())
        } catch {
            print("Decoding error: \(error)")
            return Prompt.samplePrompts[0]
        }
    }
     
    func fetchRandomTip() async throws -> String {
        guard let url = URL(string: "\(baseURL)/prompt/tip") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Update this struct if the JSON structure from your server differs
        struct RandomTipResponse: Decodable {
            let tip: String
        }
        
        do {
            let response = try JSONDecoder().decode(RandomTipResponse.self, from: data)
            return response.tip
        } catch {
            throw NetworkError.decodingError
        }
    }
}
