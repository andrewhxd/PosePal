//
//  MyLoadingView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import Foundation
import SwiftUI

struct MyLoadingView: View {
    var body: some View {
        GIFView(gifName: "myLoading") // e.g. a "myLoading.gif" in your app bundle
            .frame(width: 200, height: 200)
    }
}
