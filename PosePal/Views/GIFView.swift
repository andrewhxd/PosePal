//
//  GIFView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    let gifName: String  // without the .gif extension
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        // Load the raw GIF data
        if let gifData = try? Data(contentsOf: url) {
            // Tell WebKit that it’s a GIF and render inline
            uiView.load(
                gifData,
                mimeType: "image/gif",
                characterEncodingName: "UTF-8",
                baseURL: url.deletingLastPathComponent()
            )
        }
    }
}
