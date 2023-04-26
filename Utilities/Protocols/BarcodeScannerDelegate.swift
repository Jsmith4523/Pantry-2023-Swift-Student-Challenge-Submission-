//
//  BarcodeScannerDelegate.swift
//  Pantry
//
//  Created by Jaylen Smith on 4/13/23.
//

import Foundation

protocol BarcodeScannerDelegate: AnyObject {
    func didReceiveBarcodeString(_ barcodeString: String?)
}
