//
//  ContentView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI

struct Homeview: View {
    @State private var currentPrompt: Prompt? = Prompt.getRandomPrompt()

    var body: some View {
        TabView {
            // Home Screen
            VStack(spacing: 20) {
                // Display the current prompt
                if let prompt = currentPrompt {
                    VStack(spacing: 8) {
                        Text("Today's Prompt")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text(prompt.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Text(prompt.details)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                } else {
                    Text("No prompt available.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                // Button to generate a random prompt
                Button(action: {
                    currentPrompt = Prompt.getRandomPrompt()
                }) {
                    Text("Generate Random Prompt")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            // Prompts Archive Screen
            PromptArchiveView()
                .tabItem {
                    Label("Archive", systemImage: "doc.text.fill")
                }

            // Memories Library Screen
            MemoriesLibraryView()
                .tabItem {
                    Label("Library", systemImage: "photo.fill")
                }
        }
        // Allow for gesturing across tabs
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

#Preview {
    Homeview()
}

// Placeholder Views for Navigation
struct PromptArchiveView: View {
    var body: some View {
        Text("Prompt Archive")
            .font(.largeTitle)
            .navigationTitle("Prompt Archive")
    }
}

struct MemoriesLibraryView: View {
    var body: some View {
        Text("Memories Library")
            .font(.largeTitle)
            .navigationTitle("Memories Library")
    }
}
