//
//  Photocell.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI
import Photos

struct PhotoCell: View {
    let asset: PHAsset
    @State private var image: UIImage?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                } else {
                    Color.gray.opacity(0.3) // Placeholder for loading
                }
            }
            .clipped()
            .cornerRadius(8)
            .onAppear {
                loadImage()
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func loadImage() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.resizeMode = .exact

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 200, height: 200),
            contentMode: .aspectFill,
            options: options
        ) { result, _ in
            DispatchQueue.main.async {
                self.image = result
            }
        }
    }
}
