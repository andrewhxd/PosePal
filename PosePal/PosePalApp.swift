//
//  PosePalApp.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI

@main
struct PosePalApp: App {
    init() {
        PhotoManager.createAlbumIfNeeded { _ in }
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
