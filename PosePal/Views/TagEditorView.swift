//
//  TagEditorView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import SwiftUI
import Photos

struct TagEditorView: View {
    let asset: PHAsset
    @State private var tags: Set<PhotoTag>
    @State private var newTag = ""
    @Environment(\.dismiss) var dismiss
    
    init(asset: PHAsset) {
        self.asset = asset
        _tags = State(initialValue: PhotoManager.getPhotoTags(photoId: asset.localIdentifier))
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Add Tag") {
                    HStack {
                        TextField("New tag", text: $newTag)
                        Button("Add") {
                            if !newTag.isEmpty {
                                tags.insert(PhotoTag(name: newTag))
                                newTag = ""
                            }
                        }
                    }
                }
                
                Section("Current Tags") {
                    ForEach(Array(tags), id: \.self) { tag in
                        Text(tag.name)
                            .swipeActions {
                                Button(role: .destructive) {
                                    tags.remove(tag)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .navigationTitle("Edit Tags")
            .navigationBarItems(
                trailing: Button("Done") {
                    PhotoManager.savePhotoTags(photoId: asset.localIdentifier, tags: tags)
                    dismiss()
                }
            )
        }
    }
}
