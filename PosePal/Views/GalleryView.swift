//
//  GalleryView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI
import Photos

struct GalleryView: View {
   @State private var photos: PHFetchResult<PHAsset>?
   @Environment(\.dismiss) var dismiss
   
   var body: some View {
       NavigationView {
           ScrollView {
               if let photos = photos {
                   LazyVGrid(columns: [
                       GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible())
                   ], spacing: 2) {
                       ForEach(0..<photos.count, id: \.self) { index in
                           PhotoCell(asset: photos[index])
                       }
                   }
               }
           }
           .navigationTitle("My Gallery")
           .navigationBarItems(trailing: Button("Done") { dismiss() })
           .onAppear { loadPhotos() }
       }
   }
   
    func loadPhotos() {
        PhotoManager.requestAuthorization { authorized in
            if authorized {
                DispatchQueue.main.async {
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "title = %@", PhotoManager.albumName)
                    let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                    
                    if let album = collections.firstObject {
                        let photosOptions = PHFetchOptions()
                        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                        self.photos = PHAsset.fetchAssets(in: album, options: photosOptions)
                    }
                }
            }
        }
    }
}

struct PhotoCell: View {
   let asset: PHAsset
   @State private var image: UIImage?
   
   var body: some View {
       GeometryReader { geometry in
           if let image = image {
               Image(uiImage: image)
                   .resizable()
                   .scaledToFill()
                   .frame(width: geometry.size.width, height: geometry.size.width)
                   .clipped()
           }
       }
       .aspectRatio(1, contentMode: .fit)
       .onAppear {
           loadImage()
       }
   }
   
   func loadImage() {
       let manager = PHImageManager.default()
       let options = PHImageRequestOptions()
       options.deliveryMode = .fastFormat
       
       manager.requestImage(for: asset,
                          targetSize: CGSize(width: 300, height: 300),
                          contentMode: .aspectFill,
                          options: options) { result, _ in
           image = result
       }
   }
}
