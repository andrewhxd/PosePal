//
//  TagEditorView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import SwiftUI
import Photos

import SwiftUI
import Photos

struct TagEditorView: View {
    let asset: PHAsset
    @State private var tags: Set<PhotoTag>
    @State private var newTag = ""
    @Environment(\.dismiss) var dismiss
    
    // 1) Track when we should show fullscreen
    @State private var isShowingFullScreen = false
    
    init(asset: PHAsset) {
        self.asset = asset
        _tags = State(initialValue: PhotoManager.getPhotoTags(photoId: asset.localIdentifier))
    }
    
    var body: some View {
        NavigationView {
            List {
                // Photo section at the top
                Section {
                    // 2) Tap gesture to trigger fullscreen
                    PhotoCell(asset: asset)
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            isShowingFullScreen = true
                        }
                }
                
                // Add Tag section
                Section("Add Tag") {
                    HStack {
                        TextField("New tag", text: $newTag)
                        Button("Add") {
                            let trimmedTag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmedTag.isEmpty else { return }
                            tags.insert(PhotoTag(name: trimmedTag))
                            newTag = ""
                        }
                    }
                }
                
                // Current Tags section
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
            // 3) Fullscreen cover that shows the tapped photo
            .fullScreenCover(isPresented: $isShowingFullScreen) {
                FullScreenPhotoView(asset: asset, tags: []) // or pass actual tags if needed
            }
        }
    }
}

