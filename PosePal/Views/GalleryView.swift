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
               List {
                   ForEach(viewModel.photos, id: \.localIdentifier) { asset in
                       NavigationLink(destination: PhotoDetailView(asset: asset)) {
                           PhotoRow(asset: asset)
                       }
                   }
               }
               .listStyle(.plain)
               .navigationTitle("PosePal Album")
               .navigationBarItems(trailing: Button("Done") { dismiss() })
           }
       }
}
