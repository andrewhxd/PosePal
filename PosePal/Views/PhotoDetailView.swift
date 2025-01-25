//
//  PhotoDetailView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import Foundation
import SwiftUI
import Photos

struct PhotoDetailView: View {
   let asset: PHAsset
   @Environment(\.dismiss) var dismiss
   @State private var image: UIImage?
   
   var body: some View {
       NavigationView {
           GeometryReader { geo in
               if let image = image {
                   Image(uiImage: image)
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: geo.size.width)
               }
           }
           .navigationBarItems(
               trailing: Button("Done") { dismiss() }
           )
       }
       .onAppear(perform: loadFullImage)
   }
   
   private func loadFullImage() {
       let options = PHImageRequestOptions()
       options.deliveryMode = .highQualityFormat
       options.isNetworkAccessAllowed = true
       
       PHImageManager.default().requestImage(
           for: asset,
           targetSize: PHImageManagerMaximumSize,
           contentMode: .aspectFit,
           options: options
       ) { result, _ in
           image = result
       }
   }
}
