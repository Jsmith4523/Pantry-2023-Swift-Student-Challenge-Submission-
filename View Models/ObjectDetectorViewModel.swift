//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/16/23.
//

import Foundation
import AVKit
import CoreML
import UIKit
import Vision
import SwiftUI

///View model for detecting objects
final class ObjectDetectorViewModel: NSObject, ObservableObject {
    
    @Published var didDetectObject = false
            
    @Published var deviceHasTorch = false
    @Published var torchActive = false
    
    @AppStorage ("objectDectectionEnabled") var objectDectectionEnabled = true
    
    @Published var isShowingAuthRequestView = false
        
    private let detectionManager = ObjectDetectionManager()
    
    private let session = AVCaptureSession()
    private var captureOutput: AVCapturePhotoOutput!
    private var device: AVCaptureDevice!
    
    weak private var objectDelegate: ObjectScannerDelegate?
    weak private var barcodeDelegate: BarcodeScannerDelegate?
        
    func setObjectDelegate(_ delegate: ObjectScannerDelegate) {
        self.objectDelegate = delegate
    }
    
    func setBarcodeDelegate(_ delegate: BarcodeScannerDelegate) {
        self.barcodeDelegate = delegate
    }
    
    override init() {
        super.init()
        self.detectionManager.setDelegate(self)
    }
    
    lazy var barcodeRequest: VNDetectBarcodesRequest = {
        let request = VNDetectBarcodesRequest { request, err in
            guard err == nil else {
                return
            }
            self.processBarcodeRequest(request)
        }
        
        return request
    }()
    
    let view = UIView(frame: UIScreen.main.bounds)
    
    func toggleTorch() {
        guard let device, deviceHasTorch else {
            return
        }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = torchActive ? .off : .on
            device.unlockForConfiguration()
            
            self.torchActive = (device.torchMode == .on ? true : false)
        } catch {
            print("Unable to toggle torch")
        }
    }
    
    ///Determines if there is a device available if not nil
    func deviceIsAvailable() -> Bool {
        withAnimation {
            return !(self.device == nil)
        }
    }
    
    private func setupSession() {
        self.device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        
        guard let device else {
            print("Device cannot be used")
            return
        }
        
        DispatchQueue.main.async {
            self.deviceHasTorch = device.hasTorch
        }
        
        do {
            session.beginConfiguration()
            
            let input = try AVCaptureDeviceInput(device: device)
            
            guard session.canAddInput(input) else {
                print("Input cannot be added")
                return
            }
            
            session.addInput(input)
            
            DispatchQueue.main.async {
                let preview = AVCaptureVideoPreviewLayer(session: self.session)
                preview.frame = self.view.frame
                preview.videoGravity = .resizeAspectFill
                
                self.view.layer.addSublayer(preview)
            }
            
            createVideoOutput()
                        
            session.commitConfiguration()
            
        
        } catch {
            print(error.localizedDescription)
        }
        
        restartSession()
    }
    
    func capture() {
        let captureSettings = AVCapturePhotoSettings()
        
        guard let captureOutput else {
            return
        }
        
        captureOutput.capturePhoto(with: captureSettings, delegate: self)
    }
    
    private func createVideoOutput() {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: .global(qos: .userInitiated))
        
        guard session.canAddOutput(output) else {
            print("Video Data Output cannot be added")
            return
        }
        
        session.addOutput(output)
        
        self.captureOutput = AVCapturePhotoOutput()
        
        guard session.canAddOutput(captureOutput) else {
            print("Capture Output cannot be added")
            return
        }
        
        session.addOutput(captureOutput)
    }
    
    func requestAccess() {
        AVCaptureDevice.requestAccess(for: .video) { success in
            guard success else {
                return
            }
            self.setupSession()
        }
    }
    
    func checkAuthStatus() {

        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isShowingAuthRequestView = true
            }
        case .authorized:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.setupSession()
            }
        default:
            break
        }
    }
    
    func restartSession() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.detectionManager.continueScanning = true
            }
            DispatchQueue.main.async {
                withAnimation {
                    self.didDetectObject = false
                }
            }
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
        }
    }
}

//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension ObjectDetectorViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard objectDectectionEnabled else {
            return
        }
        self.detectionManager.createRequest(for: sampleBuffer)
    }
}

//MARK: - ObjectScannerDelegate
extension ObjectDetectorViewModel: ObjectScannerDelegate {
    func didDetectObject(prediction: Prediction?) {
        DispatchQueue.main.async {
            withAnimation {
                self.didDetectObject = true
            }
        }
        stopSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.objectDelegate?.didDetectObject(prediction: prediction)
        }
    }
}

extension ObjectDetectorViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
                
        if let imgData = photo.fileDataRepresentation() {
            guard let uiImage = UIImage(data: imgData) else {
                return
            }
            
            guard let ciImage = CIImage(image: uiImage) else {
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
                
                do {
                    try handler.perform([self.barcodeRequest])
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - Vision
extension ObjectDetectorViewModel {
    
    private func processBarcodeRequest(_ request: VNRequest) {
        guard let result = request.results, let barcodeResult = result.first as? VNBarcodeObservation, let upc = barcodeResult.payloadStringValue else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        barcodeDelegate?.didReceiveBarcodeString(upc)
    }
}
