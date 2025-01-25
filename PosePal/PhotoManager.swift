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
    static let shared = PhotoManager()
    static let albumName = "PosePal"
        
    static func createAlbumIfNeeded(completion: @escaping (PHAssetCollection?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion(nil)
                return
            }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", PhotoManager.albumName)
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let album = collections.firstObject {
                completion(album)
            } else {
                var placeholder: String?
                
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: PhotoManager.albumName)
                    placeholder = request.placeholderForCreatedAssetCollection.localIdentifier
                }) { success, error in
                    guard success, let identifier = placeholder else {
                        completion(nil)
                        return
                    }
                    
                    let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [identifier], options: nil)
                    completion(collection.firstObject)
                }
            }
        }
    }
    
    static func requestAuthorization(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }
    
    static func save(image: UIImage) {
        createAlbumIfNeeded { album in
            guard let album = album else { return }
            
            PHPhotoLibrary.shared().performChanges({
                let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let placeholder = assetRequest.placeholderForCreatedAsset!
                albumChangeRequest?.addAssets([placeholder] as NSFastEnumeration)
            })
        }
    }
}
