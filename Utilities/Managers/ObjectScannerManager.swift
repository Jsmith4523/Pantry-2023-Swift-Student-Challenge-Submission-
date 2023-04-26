//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/16/23.
//

import Foundation
import Vision
import UIKit

class ObjectDetectionManager {
    
    var continueScanning = true
    
    private var request: VNCoreMLRequest?
    
    init() {
        self.setupRequest()
    }
    
    weak private var scannerDelegate: ObjectScannerDelegate?
    
    func setDelegate(_ delegate: ObjectScannerDelegate) {
        self.scannerDelegate = delegate
    }
    
    private func setupRequest() {
        guard let model = try? VNCoreMLModel(for: ObjectDetectionModel(configuration: MLModelConfiguration()).model) else {
            fatalError("Unable to configure FruitVegtableDetector model!")
        }
    
        self.request = VNCoreMLRequest(model: model, completionHandler: requestCompleted)
    }
    
    private func requestCompleted(request: VNRequest, err: Error?) {
        guard let results = request.results as? [VNRecognizedObjectObservation], let prediction = results.first, err == nil, continueScanning else  {
            return
        }
        
        //The name of what the model thinks the item is...
        guard let prediction = prediction.labels.first else {
            return
        }
        
        //Realize I named the objects all wrong and do not know to change...
        let identifer = prediction.identifier
        
        self.continueScanning = false
        scannerDelegate?.didDetectObject(prediction: Prediction.match(with: identifer))
    }
    
    func createRequest(for buffer: CMSampleBuffer) {
        do {
            guard let pixelBuffer = try? CMSampleBuffer(copying: buffer), let request else {
                print("Unable to create request")
                return
            }
            
            let imageRequest = VNImageRequestHandler(cmSampleBuffer: pixelBuffer)
            try? imageRequest.perform([request])
        }
    }
}

enum Prediction {
    case apple, banana, carrot, cucumber, grapes, onion, oranges, tomato
    
    static func match(with string: String) -> Self? {
        
        switch string {
        case "apple":
            return .apple
        case "banana":
            return .banana
        case "carrot":
            return .carrot
        case "cucumber":
            return .cucumber
        case "grapes":
            return .grapes
        case "onion":
            return .onion
        case "oranges":
            return .oranges
        case "tomato":
            return .tomato
        default:
            return nil
        }
    }
    
    var type: MerchandiseType {
        switch self {
        case .apple:
            return .fruit
        case .banana:
            return .fruit
        case .carrot:
            return .vegetables
        case .cucumber:
            return .vegetables
        case .grapes:
            return .fruit
        case .onion:
            return .vegetables
        case .oranges:
            return .fruit
        case .tomato:
            return .vegetables
        }
    }
    
    var identifier: String {
        switch self {
            
        case .apple:
            return "Apples"
        case .banana:
            return "Bananas"
        case .carrot:
            return "Carrots"
        case .cucumber:
            return "Cucumbers"
        case .grapes:
            return "Grapes"
        case .onion:
            return "Onions"
        case .oranges:
            return "Oranges"
        case .tomato:
            return "Tomatos"
        }
    }
}
