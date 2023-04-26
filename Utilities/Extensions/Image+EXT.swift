//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/15/23.
//

import Foundation
import SwiftUI

extension Image {
    
    func hangingButton() -> some View {
        return self
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .foregroundColor(.accentColor)
            .shadow(radius: 1)
            .padding()
    }
}
