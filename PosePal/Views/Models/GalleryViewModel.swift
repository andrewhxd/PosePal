//
//  GalleryViewModel.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import Photos

class GalleryViewModel: ObservableObject {
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
}
