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
               LazyVGrid(columns: [
                   GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible(), spacing: 1)
               ], spacing: 1) {
                   ForEach(viewModel.photos, id: \.localIdentifier) { asset in
                       PhotoCell(asset: asset)
                   }
               }
               .padding(1)
           }
           .navigationTitle("Gallery")
           .navigationBarItems(trailing: Button("Done") { dismiss() })
       }
   }
}


  
