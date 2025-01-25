//
//  PhotoRow.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI
import UIKit
import Photos


struct PhotoRow: View {
   let asset: PHAsset
   @State private var thumbnail: UIImage?
   
   var body: some View {
       HStack {
           if let image = thumbnail {
               Image(uiImage: image)
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(width: 80, height: 80)
                   .cornerRadius(4)
           } else {
               Color.gray
                   .frame(width: 80, height: 80)
                   .cornerRadius(4)
           }
           
           VStack(alignment: .leading) {
               Text(asset.creationDate?.formatted() ?? "Unknown Date")
                   .font(.headline)
               Text("\(asset.pixelWidth) × \(asset.pixelHeight)")
                   .font(.subheadline)
                   .foregroundColor(.secondary)
           }
           
           Spacer()
       }
       .padding(.vertical, 4)
       .onAppear(perform: loadThumbnail)
   }
   
   private func loadThumbnail() {
       let options = PHImageRequestOptions()
       options.deliveryMode = .opportunistic
       
       PHImageManager.default().requestImage(
           for: asset,
           targetSize: CGSize(width: 160, height: 160),
           contentMode: .aspectFill,
           options: options
       ) { result, _ in
           thumbnail = result
       }
   }
}
