//
//  CarouselView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import Foundation
import SwiftUI
import Photos

struct CarouselView: View {
    let photos: [PHAsset]
    @State private var currentIndex = 0
    @State private var offset: CGFloat = 0
    @State private var isAnimating = true
    
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    var visiblePhotos: [PHAsset] {
        // Create a window of visible photos
        let window = 5 // Show 5 photos at a time
        var indices = Array(currentIndex - 2...currentIndex + 2)
        indices = indices.map { i in
            let n = photos.count
            return ((i % n) + n) % n // Handle negative numbers correctly
        }
        return indices.map { photos[$0] }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let itemWidth = geometry.size.width * 0.7
            
            HStack(spacing: itemWidth * 0.2) {
                ForEach(Array(visiblePhotos.enumerated()), id: \.1.localIdentifier) { index, asset in
                    PhotoCell(asset: asset)
                        .frame(width: itemWidth, height: itemWidth)
                        .scaleEffect(index == 2 ? 1.0 : 0.8)
                        .opacity(index == 2 ? 1.0 : 0.6)
                }
            }
            .offset(x: -itemWidth * 2.2 + offset)
            .animation(.easeInOut(duration: 0.3), value: currentIndex)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isAnimating = false
                        offset = value.translation.width
                    }
                    .onEnded { value in
                        let change = value.translation.width
                        if abs(change) > 50 {
                            currentIndex = ((currentIndex + (change > 0 ? -1 : 1)) % photos.count + photos.count) % photos.count
                        }
                        offset = 0
                        isAnimating = true
                    }
            )
        }
        .frame(height: 300)
        .onReceive(timer) { _ in
            if isAnimating {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentIndex = ((currentIndex + 1) % photos.count + photos.count) % photos.count
                }
            }
        }
    }
}
