//
//  CameraViewModel.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//
import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject {
    @EnvironmentObject var viewModel: CameraViewModel
    @Published var session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    
    override init() {
        super.init()
        setupCamera()
    }
    
    func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
              for: .video, position: .back) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) && session.canAddOutput(output) {
                session.addInput(input)
                session.addOutput(output)
            }
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }
        } catch {
            print("Camera setup error: \(error.localizedDescription)")
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                    didFinishProcessingPhoto photo: AVCapturePhoto,
                    error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        // Save photo to gallery or your app's storage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
