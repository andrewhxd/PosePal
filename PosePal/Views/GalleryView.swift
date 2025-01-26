//
//  GalleryView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI
import Photos

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 2) {
                        ForEach(viewModel.filteredPhotos, id: \.localIdentifier) { asset in
                            PhotoCell(asset: asset)
                                .onTapGesture {
                                    viewModel.selectedPhoto = asset
                                    viewModel.showingTagEditor = true
                                }
                        }
                    }
                }
            }
            .navigationTitle("My Gallery")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
            .sheet(isPresented: $viewModel.showingTagEditor) {
                if let asset = viewModel.selectedPhoto {
                    TagEditorView(asset: asset)
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search tags...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}
