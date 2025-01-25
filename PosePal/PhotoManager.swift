//
//  PhotoManager.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import Foundation
import Photos
import UIKit

class PhotoManager {
    static let albumName = "PosePal"
    
    static func createAlbumIfNeeded(completion: @escaping (PHAssetCollection?) -> Void) {
        var albumPlaceholder: PHObjectPlaceholder?
        
        // Check if album exists
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let album = collections.firstObject {
            completion(album)
            return
        }
        
        // Create new album
        PHPhotoLibrary.shared().performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, error in
            guard success else {
                completion(nil)
                return
            }
            
            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder!.localIdentifier], options: nil)
            completion(fetchResult.firstObject)
        })
    }
    
    static func save(image: UIImage) {
        createAlbumIfNeeded { album in
            guard let album = album else { return }
            
            PHPhotoLibrary.shared().performChanges({
                let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                albumChangeRequest?.addAssets([assetRequest.placeholderForCreatedAsset!] as NSFastEnumeration)
            })
        }
    }
}
