//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/16/23.
//

import Foundation
import CoreML
import AVFoundation
import SwiftUI

struct ObjectScannerView: View {
    
    @ObservedObject var detectorModel: ObjectDetectorViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CameraView(detectorModel: detectorModel)
            VStack {
                Spacer()
                    .frame(height: 200)
                Text(detectorModel.objectDectectionEnabled ? "Place barcode or produce within view" : "Place barcode within view")
                    .font(.system(size: 18).bold())
                if detectorModel.didDetectObject {
                    Text("Detecting object...")
                        .font(.system(size: 16.5).bold())
                        .padding(.top, 7)
                }
                Spacer()
            }
            .multilineTextAlignment(.center)
        }
    }
}

fileprivate struct CameraView: UIViewRepresentable {
    
    @ObservedObject var detectorModel: ObjectDetectorViewModel
    
    func makeUIView(context: Context) -> UIView {
        return context.coordinator.view
    }
    
    func makeCoordinator() -> ObjectDetectorViewModel {
        detectorModel
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    typealias UIViewType = UIView
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
       ObjectScannerView(detectorModel: ObjectDetectorViewModel())
    }
}
