//
//  PhotographyTipsView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import Foundation
import SwiftUI

struct PhotographyTipsView: View {
    @Environment(\.dismiss) private var dismiss
    
    // The tip text we fetch from the server
    @State private var tip: String = "Loading..."
    
    // List of possible image names in your Assets
    private let imageNames = ["Image 1", "Image", "Image 2", "Image 3", "Image 4", "Image 5"]  // <-- add as many as you have
        
    // State variable for the chosen random image
    @State private var chosenImageName: String = "1"
    
    var body: some View {
        // We can hide the default nav bar and use a custom layout
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // A fun icon or emoji at the top
                Image(systemName: "camera.aperture")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                // A heading or short descriptive line
                Text("📸 Pro Photo Tip")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Actual tip text
                Text(tip)
                    // 1) Custom font and size.
                    //    You can use a system font or a custom font name if it’s included in your project.
                    .font(.system(size: 18, weight: .regular, design: .default))

                    // 2) Change the color. This uses a darker gray.
                    .foregroundColor(.gray)

                    // 3) Increase line spacing for multi-line text
                    .lineSpacing(8)

                    // 4) Control text alignment
                    .multilineTextAlignment(.leading)

                    // 5) Adjust horizontal padding for comfortable reading
                    .padding(.horizontal, 16)
                
                Spacer()
                
                // 1) Show the random image from assets
                
                Image(chosenImageName)
                    .resizable()
                    .scaledToFit()
                    // Let it grow as wide as possible within some padding
                    .frame(maxWidth: .infinity)
                    // Remove or greatly reduce any fixed height constraints
                    //.frame(height: 200) // <- remove if it’s adding excess whitespace
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                // Close button at the bottom
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Close")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.bottom, 20)
            }
        }
        .task {
            await fetchTip()
            pickRandomImage()
        }
    }
    
    // Make the async call to NetworkManager
    private func fetchTip() async {
        do {
            let fetchedTip = try await NetworkManager.shared.fetchRandomTip()
            tip = fetchedTip
        } catch {
            tip = "Unable to load tip. Please try again later."
        }
    }
    
    // Pick a random image from the asset names
    private func pickRandomImage() {
        if let randomName = imageNames.randomElement() {
            chosenImageName = randomName
        }
    }
}
