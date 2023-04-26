//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/18/23.
//

import Foundation
import SwiftUI

extension View {
    func customCapsuleWhite() -> some View {
        Capsule()
            .foregroundColor(Color.white)
            .frame(height: 1)
    }
    func customCapsuleBrandColor() -> some View {
        Capsule()
            .foregroundColor(Color.appPrimary)
            .frame(height: 1)
    }
    func customCapsuleBlack() -> some View {
        Capsule()
            .foregroundColor(Color.black)
            .frame(height: 1)
    }
}
