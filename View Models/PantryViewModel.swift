//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/12/23.
//

import Foundation
import UIKit
import SwiftUI

enum ScannedItemType: Identifiable {
    
    case manual
    case edit(UUID)
    case barcode(String)
    case produce(Prediction)
    
    var id: String {
        switch self {
        case .manual:
            return "Manual Entry"
        case .barcode(_):
            return "Add item"
        case .produce(_):
            return "Add Produce"
        case .edit(_):
            return "Edit Item"
        }
    }
}

final class PantryViewModel: ObservableObject {
        
    @Published var isShowingPantryView = false
    
    @Published var scannedItemView: ScannedItemType?
                    
    @Published var merchandise = [Merchandise]()
    
    @AppStorage ("didOnboard") var didOnboard = false    
    @AppStorage ("expirationDays") var expirationDays = 3
    
    func throwAwayMerchandise(_ merchandise: Merchandise) {
        self.merchandise.removeAll(where: {$0.id == merchandise.id})
        saveData()
    }
    
    func addMerchandise(_ merchandise: Merchandise) {
        self.merchandise.append(merchandise)
        self.saveData()
    }
    
    init() {
        getPantryMerchandise()
    }
    
    private func getPantryMerchandise() {
        //CoreData is not avalibale in a swift playground app. So I will use UserDefaults for the meantime...
        
        if let merchData = UserDefaults.standard.data(forKey: "merchandise") {
            do {
                let merchandise = try JSONDecoder().decode([Merchandise].self, from: merchData)
                self.merchandise = merchandise
            } catch {
                print("Unable to get merchandise data")
            }
        } else {
            //Create an empty area...
            UserDefaults.standard.set([Merchandise](), forKey: "merchandise")
        }
    }
    
    private func saveData() {
        do {
            let data = try JSONEncoder().encode(merchandise)
            UserDefaults.standard.set(data, forKey: "merchandise")
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            getPantryMerchandise()
        } catch {
            print("unable to save!")
        }
    }
}

//MARK: - BarcodeScannerDelegate
extension PantryViewModel: BarcodeScannerDelegate {
    func didReceiveBarcodeString(_ barcodeString: String?) {
        if let barcodeString {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.scannedItemView = .barcode(barcodeString)
            }
        }
    }
}

//MARK: - ObjectScannerDelegate
extension PantryViewModel: ObjectScannerDelegate {
    func didDetectObject(prediction: Prediction?) {
        guard let prediction else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scannedItemView = .produce(prediction)
        }
    }
}
