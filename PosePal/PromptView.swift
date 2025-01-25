//
//  PromptView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI

struct PromptView: View {
    @State private var currentPrompt: Prompt? = Prompt.getRandomPrompt()

    var body: some View {
        VStack(spacing: 16) {
            if let prompt = currentPrompt {
                Text("Today's Prompt")
                    .font(.headline)
                Text(prompt.title)
                    .font(.title)
                Text(prompt.details)
                    .font(.body)
                    .padding()
            } else {
                Text("No prompt available.")
            }

            Button("Generate Random Prompt") {
                // Update the currentPrompt with a new random prompt
                currentPrompt = Prompt.getRandomPrompt()
            }
        }
        .padding()
    }
}
