//
//  GalleryViewModel.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI
import Photos

class GalleryViewModel: ObservableObject {
    @Published var showingDetail = false
    @Published var selectedAsset: PHAsset?
    @Published var photos: [PHAsset] = []
   
   init() {
       loadPhotos()
   }
   
   func loadPhotos() {
       PHPhotoLibrary.requestAuthorization { status in
           guard status == .authorized else { return }
           
           let fetchOptions = PHFetchOptions()
           fetchOptions.predicate = NSPredicate(format: "title = %@", PhotoManager.albumName)
           let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
           
           if let album = collections.firstObject {
               let photosOptions = PHFetchOptions()
               photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
               let fetchedPhotos = PHAsset.fetchAssets(in: album, options: photosOptions)
               
               DispatchQueue.main.async {
                   self.photos = (0..<fetchedPhotos.count).compactMap { fetchedPhotos.object(at: $0) }
               }
           }
       }
   }
    
    func getRecentPhotos(count: Int) -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", PhotoManager.albumName)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let album = collections.firstObject {
            let photosOptions = PHFetchOptions()
            photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchedPhotos = PHAsset.fetchAssets(in: album, options: photosOptions)
            return (0..<min(count, fetchedPhotos.count)).compactMap { fetchedPhotos.object(at: $0) }
        }
        return []
    }
    
    func getRandomPhotos(count: Int) -> [PHAsset] {
       let fetchOptions = PHFetchOptions()
       fetchOptions.predicate = NSPredicate(format: "title = %@", PhotoManager.albumName)
       let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
       
       if let album = collections.firstObject {
           let photosOptions = PHFetchOptions()
           let fetchedPhotos = PHAsset.fetchAssets(in: album, options: photosOptions)
           let totalCount = fetchedPhotos.count
           
           var randomPhotos: [PHAsset] = []
           var usedIndexes: Set<Int> = []
           
           while randomPhotos.count < min(count, totalCount) {
               let randomIndex = Int.random(in: 0..<totalCount)
               if !usedIndexes.contains(randomIndex) {
                   usedIndexes.insert(randomIndex)
                   randomPhotos.append(fetchedPhotos.object(at: randomIndex))
               }
           }
           return randomPhotos
       }
       return []
    }
}
