//
//  CameraView.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @EnvironmentObject var viewModel: CameraViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Camera preview
            CameraPreviewView(session: viewModel.session)
                .ignoresSafeArea()
                .background(.black) // Add this to see if camera is loading
            
            // Controls overlay
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    Spacer()
                }
                
                Spacer()
                
                // Capture button
                Button(action: viewModel.capturePhoto) {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 65, height: 65)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            viewModel.session.startRunning()
        }
        .onDisappear {
            viewModel.session.stopRunning()
        }
    }
}
