//
//  CarouselView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import Foundation
import SwiftUI
import Photos

extension PHAsset: Identifiable {
    public var id: String {
        localIdentifier
    }
}

struct CarouselView: View {
    let photos: [PHAsset]
    let tags: [PhotoTag]
    
    @State private var currentIndex = 0
    @State private var offset: CGFloat = 0
    @State private var isAnimating = true
    
    // For fullscreen presentation
    @State private var selectedAsset: PHAsset? = nil
    
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    var visiblePhotos: [PHAsset] {
        var indices = Array(currentIndex - 2...currentIndex + 2)
        indices = indices.map { i in
            let n = photos.count
            // If there are no photos, this won't be used anyway
            return ((i % n) + n) % n
        }
        return indices.map { photos[$0] }
    }
    
    var body: some View {
        // If there are no photos, show placeholder
        if photos.isEmpty {
            VStack {
                Text("No photos yet!")
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                Text("Add some photos to get started.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(height: 300)
        } else {
            GeometryReader { geometry in
                let itemWidth = geometry.size.width * 0.7
                
                // 1) Reduced horizontal spacing
                HStack(spacing: itemWidth * 0.08) {
                    ForEach(Array(visiblePhotos.enumerated()), id: \.1.localIdentifier) { index, asset in
                        PhotoCell(asset: asset)
                            .frame(width: itemWidth, height: itemWidth)
                            .scaleEffect(index == 2 ? 1.0 : 0.8)
                            .opacity(index == 2 ? 1.0 : 0.6)
                            .onTapGesture {
                                selectedAsset = asset
                            }
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
                // Only auto-scroll if we have photos and are animating
                if isAnimating, !photos.isEmpty {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentIndex = ((currentIndex + 1) % photos.count + photos.count) % photos.count
                    }
                }
            }
            .fullScreenCover(item: $selectedAsset) { asset in
                // If you want different tags per photo, map them here
                FullScreenPhotoView(asset: asset, tags: tags)
            }
        }
    }
}


