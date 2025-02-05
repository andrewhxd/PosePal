//
//  CameraViewModel.swift
//  PosePal
//
//  Created by Andrew Xue on 1/25/25.
//
import SwiftUI
import AVFoundation
import Photos

class CameraViewModel: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var cameraPosition: AVCaptureDevice.Position = .back
    private let output = AVCapturePhotoOutput()
        
    override init() {
        super.init()
        setupCamera()
    }
        
    func switchCamera() {
        session.beginConfiguration()
            
        // Remove existing input
        session.inputs.forEach { session.removeInput($0) }
            
        // Switch position
        cameraPosition = cameraPosition == .back ? .front : .back
            
        // Setup new camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition),
            let input = try? AVCaptureDeviceInput(device: device) {
            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
            
        session.commitConfiguration()
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
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
            
        guard let imageData = photo.fileDataRepresentation(),
                let image = UIImage(data: imageData) else {
            print("Error converting photo data")
            return
        }
            
        // Save to PosePal album
        PhotoManager.save(image: image)
    }
}
