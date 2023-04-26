//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/16/23.
//

import Foundation

protocol ObjectScannerDelegate: AnyObject {
    func didDetectObject(prediction: Prediction?)
}
