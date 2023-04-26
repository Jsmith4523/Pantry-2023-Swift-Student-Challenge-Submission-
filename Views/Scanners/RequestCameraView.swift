//
//  SwiftUIView.swift
//  
//
//  Created by Jaylen Smith on 4/17/23.
//

import SwiftUI

struct CameraPermissionView: View {
    
    @ObservedObject var dectectorModel: ObjectDetectorViewModel
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.appPrimary.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                    .frame(height: 200)
                Image(systemName: "barcode.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                Spacer()
                    .frame(height: 20)
                Text("Camera Permission Request")
                    .font(.system(size: 28).bold())
                Text("In order to get the most out of Pantry, we require the use of your device's camera.")
                    .font(.system(size: 18))
                Spacer()
                Button {
                    dismiss()
                    dectectorModel.requestAccess()
                } label: {
                    Text("Request")
                        .padding()
                        .foregroundColor(.appPrimary)
                        .frame(width: 300)
                        .background(Color.white)
                        .cornerRadius(30)
                }
                Spacer()
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
        .interactiveDismissDisabled()
    }
}

struct CPV_Previews: PreviewProvider {
    static var previews: some View {
        CameraPermissionView(dectectorModel: ObjectDetectorViewModel())
    }
}
