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
                        .frame(width: geo.size.width, height: geo.size.width)
                } else {
                    Color.gray.opacity(0.3)
                }
            }
            .clipped()
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(1)
    }
    
    private func loadImage() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.resizeMode = .exact
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3),
            contentMode: .aspectFill,
            options: options
        ) { result, info in
            if let error = info?[PHImageErrorKey] as? Error {
                print("Photo load error: \(error)")
            }
            DispatchQueue.main.async {
                self.image = result
            }
        }
    }
}
