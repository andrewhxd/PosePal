//
//  ContentView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI

struct HomeView: View {
    
    // Camera Var
    @StateObject private var cameraViewModel = CameraViewModel()
    @State private var isShowingCamera = false
    
    let challenge = "Strike a pose with your favorite book!"
    let completedCount = 12
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Today's Challenge Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TODAY'S CHALLENGE")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                        
                        Text(challenge)
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
                    
                    // Quick Actions
                    HStack(spacing: 16) {
                        QuickActionButton(
                            title: "Random Prompt",
                            icon: "shuffle",
                            action: { /* Handle random */ }
                        )
                        
                        QuickActionButton(
                            title: "My Gallery",
                            icon: "photo.on.rectangle",
                            action: { /* Handle gallery */ }
                        )
                    }
                    
                    // Recent Memories
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recent Memories")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button(action: { /* Handle view all */ }) {
                                HStack {
                                    Text("View All")
                                        .foregroundColor(.blue)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(0..<6) { _ in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.1))
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("PosePal")
            .navigationBarItems(trailing:
                Button(action: { /* Handle calendar */ }) {
                    Image(systemName: "calendar")
                        .padding(8)
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
