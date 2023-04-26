//
//  SwiftUIView.swift
//  
//
//  Created by Jaylen Smith on 4/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct ScannerView: View {
        
    @State private var isShowingSettingsView = false
    
    @StateObject private var detectorModel = ObjectDetectorViewModel()
    
    @EnvironmentObject var pantryModel: PantryViewModel
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                Color.black.ignoresSafeArea()
                if detectorModel.deviceIsAvailable() {
                    ObjectScannerView(detectorModel: detectorModel)
                        .ignoresSafeArea()
                }
                ZStack {
                    LinearGradient(colors: [.black.opacity(0.15), .clear, .black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    VStack {
                        header
                        Spacer()
                        footerButtons
                    }
                    .padding(5)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            detectorModel.setObjectDelegate(pantryModel)
            detectorModel.setBarcodeDelegate(pantryModel)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                self.detectorModel.checkAuthStatus()
            }
        }
        .sheet(isPresented: $detectorModel.isShowingAuthRequestView) {
            CameraPermissionView(dectectorModel: detectorModel)
                .preferredColorScheme(.light)
        }
        .sheet(item: $pantryModel.scannedItemView) { type in
            ScannedProductView(scanType: type)
                .onAppear {
                    detectorModel.stopSession()
                }
                .onDisappear {
                    detectorModel.restartSession()
                }
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $pantryModel.isShowingPantryView) {
            PantryView()
                .presentationDragIndicator(.visible)
                .onAppear {
                    detectorModel.stopSession()
                }
                .onDisappear {
                    detectorModel.restartSession()
                }
                .preferredColorScheme(.light)
        }
        .sheet(isPresented: $isShowingSettingsView) {
            SettingsView()
                .onAppear {
                    detectorModel.stopSession()
                }
                .onDisappear {
                    detectorModel.restartSession()
                }
        }
        .environmentObject(pantryModel)
    }
    
    var header: some View {
        VStack {
            HStack {
                Button {
                    detectorModel.toggleTorch()
                } label: {
                    Image(systemName: detectorModel.torchActive ? "sun.min.fill" : "sun.max.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                Spacer()
                Button {
                    detectorModel.objectDectectionEnabled.toggle()
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                } label: {
                    Image(systemName: detectorModel.objectDectectionEnabled ? "carrot.fill" : "carrot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }

                Spacer()
                Button {
                    self.isShowingSettingsView.toggle()
                } label: {
                    Image(systemName: "text.justify")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .bold()
                }
            }
        }
        .shadow(radius: 1)
        .foregroundColor(.white)
        .padding()
    }
    
    var footerButtons: some View {
        HStack(spacing: 20) {
            Spacer()
            VStack {
                Button {
                    pantryModel.scannedItemView = .manual
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .bold()
                }
                Text("Manual")
                    .font(.system(size: 18).weight(.semibold))
            }
            Spacer()
            VStack {
                Button {
                    detectorModel.capture()
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 43, height: 43)
                        .padding()
                        .background(.white)
                        .clipShape(Circle())
                        .foregroundColor(.black)
                        .shadow(radius: 1)
                        .bold()
                }
                Text("Scan")
                    .font(.system(size: 18).weight(.semibold))
                
                Spacer()
                    .frame(height: 55)
            }
            Spacer()
            VStack {
                Button {
                    pantryModel.isShowingPantryView.toggle()
                } label: {
                    Image(systemName: "carrot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.appPrimary)
                        .clipShape(Circle())
                        .bold()
                }
                Text("Pantry")
                    .font(.system(size: 18).weight(.semibold))
            }
            Spacer()
        }
        .foregroundColor(.white)
    }
}

@available(iOS 16.0, *)
struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
            .environmentObject(PantryViewModel())
    }
}
