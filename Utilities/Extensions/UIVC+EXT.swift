//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/12/23.
//

import Foundation
import UIKit
import SwiftUI

extension UISheetPresentationController {
    
    //Globally sets sheets to have a corner radius of 30
    open override func containerViewWillLayoutSubviews() {
        self.preferredCornerRadius = 20
    }
}

extension UINavigationController {
    
    open override func viewWillLayoutSubviews() {
        self.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
