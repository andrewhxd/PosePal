//
//  PhotographyTipsView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/26/25.
//

import Foundation
import SwiftUI

struct PhotographyTipsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Placeholder text for photography tips.\n\nYou can add tips on lighting, composition, angles, etc.")
                .padding()
                .navigationTitle("Photography Tips")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
