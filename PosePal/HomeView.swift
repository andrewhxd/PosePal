//
//  ContentView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI

struct HomeView: View {
    // My Gallery Flag
    @State private var isShowingGallery = false
    
    // Random Prompt
    @State private var showingRandomPrompt = false
    @State private var randomPrompt: Prompt?
    
    // Prompt Model
    @StateObject private var promptViewModel = PromptViewModel()
    
    // Access the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
    // Camera Variables
    @StateObject private var cameraViewModel = CameraViewModel()
    @State private var isShowingCamera = false
    
    // Static content
    let challenge = "Strike a pose with your favorite book!"
    let completedCount = 12
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Today's Challenge Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TODAY'S CHALLENGE")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .fontWeight(.medium)
                            
                            Text(promptViewModel.currentPrompt.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("\(completedCount) friends completed this challenge")
                                .foregroundColor(.gray)
                            
                            Button(action: { isShowingCamera = true }) {
                                HStack {
                                    Image(systemName: "camera.fill")
                                    Text("Take Challenge")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .fullScreenCover(isPresented: $isShowingCamera) {
                                CameraView().environmentObject(cameraViewModel)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(16)
                        
                        
                        HStack(spacing: 17) {
                            QuickActionButton(
                                title: "Random Prompt",
                                icon: "shuffle",
                                action: {
                                    randomPrompt = Prompt.getRandomPrompt()
                                    showingRandomPrompt = true
                                }
                            )
                            .alert("Random Prompt", isPresented: $showingRandomPrompt) {
                               Button("OK", role: .cancel) { }
                            } message: {
                               Text(randomPrompt?.title ?? "")
                            }
                            .frame(maxWidth: .infinity, minHeight: 50) // Ensures equal width and consistent height
                            
                            QuickActionButton(
                                title: "My Gallery",
                                icon: "photo.on.rectangle",
                                action: { isShowingGallery = true }
                            )
                            .sheet(isPresented: $isShowingGallery) {
                               GalleryView()
                            }
                            .frame(maxWidth: .infinity, minHeight: 50) // Ensures equal width and consistent height
                        }
                        .padding()
    
                        
                        // Recent Memories
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Recent Memories")
                                    .font(.title3)
                                    .bold()
                                Spacer()
                                Button("View All") {
                                    // Handle view all action
                                }
                                .foregroundColor(.blue)
                            }
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(0..<6) { _ in
                                    Rectangle()
                                        .fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                                        .aspectRatio(1, contentMode: .fit)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("PosePal")
            .padding()
            .navigationBarItems(trailing:
                Button(action: { /* Handle calendar */ }) {
                    Image(systemName: "calendar")
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
            )
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: icon)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    HomeView()
}
