//
//  GalleryView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI
import Photos

struct GalleryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = GalleryViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 3), // Uniform 3 columns
                    spacing: 2 // Consistent spacing between items
                ) {
                    ForEach(viewModel.photos, id: \.localIdentifier) { asset in
                        PhotoCell(asset: asset)
                            .frame(height: UIScreen.main.bounds.width / 3 - 4) // Ensures uniform square height
                            .clipped() // Ensures the photo doesn't overflow its bounds
                    }
                }
                .padding(2) // Optional padding around the grid
            }
            .navigationTitle("Gallery")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}
  
