//
//  FullScreenPhotoView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import Foundation
import SwiftUI
import Photos

struct FullScreenPhotoView: View {
    let asset: PHAsset
    let tags: [PhotoTag]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            // Actual Photo
            PhotoCell(asset: asset)
                .scaledToFit()
            
            // Close Button in top-right
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
            .zIndex(2)  // Ensure button is on top
            
            // Tag overlay at the bottom
            VStack {
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tags) { tag in
                            Text(tag.name)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .zIndex(1)
        }
    }
}
