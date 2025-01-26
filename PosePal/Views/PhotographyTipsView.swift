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
    
    // Local image name array for random selection
    private let imageNames = ["Image 1", "Image", "Image 2", "Image 3", "Image 4", "Image 5"]
    
    // The chosen random image
    @State private var chosenImageName: String = "Image"
    
    // Control whether we’re showing the loading GIF or the actual content
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // 1) If loading, show the GIF spinner/animation.
            //    If done loading, show the tip + random image.
            if isLoading {
                MyLoadingView()
            } else {
                VStack(spacing: 20) {
                    // A heading or short descriptive line
                    Text("📸 Pro Photo Tip")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Actual tip text
                    Text(tip)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.gray)
                        .lineSpacing(8)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    // Random image
                    Image(chosenImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    // Close button
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
                .transition(.opacity) // Fade in
            }
        }
        // 2) Once the view appears, do our async tasks
        .task {
            await loadData()
        }
    }// Make the async call to NetworkManager
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
    
    // 3) The function that fetches data + picks an image
    private func loadData() async {
        do {
            // Fetch the tip
            let fetchedTip = try await NetworkManager.shared.fetchRandomTip()
            tip = fetchedTip
            
            // Pick a random image
            if let randomName = imageNames.randomElement() {
                chosenImageName = randomName
            }
            
            // Done loading
            isLoading = false
        } catch {
            // If we fail, set tip to an error msg, then hide loader anyway
            tip = "Unable to load tip. Please try again later."
            isLoading = false
        }
    }
    
}
