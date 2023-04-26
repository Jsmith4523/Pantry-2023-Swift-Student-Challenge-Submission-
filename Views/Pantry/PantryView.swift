//
//  SwiftUIView.swift
//  
//
//  Created by Jaylen Smith on 4/16/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct PantryView: View {
    
    @State private var isShowingNewRoomView = false
    
    @EnvironmentObject var pantryModel: PantryViewModel
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                switch pantryModel.merchandise.isEmpty {
                case true:
                    noPantryView
                case false:
                    pantry
                }
                scannerButton
            }
            .navigationTitle("My Pantry")
            .accentColor(.appPrimary)
        }
    }
    
    var scannerButton: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "barcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.appPrimary)
                        .clipShape(Circle())
                        .padding(5)
                }
            }
        }
        .padding()
    }
    
    var pantry: some View {
        ScrollView {
            VStack {
                if pantryModel.merchandise.hasExpiredMerchandise() {
                    expiredMerchandise
                }
                Spacer()
                    .frame(height: 25)
                if pantryModel.merchandise.hasExpiringMerchandise() {
                    expiringMerchandise
                }
                Spacer()
                    .frame(height: 25)
                if pantryModel.merchandise.hasSafeToEatMerchandise() {
                    safeToEatMerchandise
                }
                Spacer()
                    .frame(height: 25)
                stockView
                Spacer()
                    .frame(height: 65)
            }
            .padding()
        }
    }
    
    var noPantryView: some View {
        VStack {
            Spacer()
                .frame(height: 75)
            Text("🧀")
                .font(.system(size: 100))
            Text("Your Pantry is Empty")
                .font(.system(size: 25).bold())
            Spacer()
                .frame(height: 20)
            Text("Start adding items to your pantry in order to keep track of everything that's in your kitchen!")
                .font(.system(size: 20))
            Spacer()
        }
        .padding()
        .multilineTextAlignment(.center)
    }
    
    var safeToEatMerchandise: some View {
        VStack(alignment: .leading) {
            Section {
                ForEach(pantryModel.merchandise.canEat()) { merchandise in
                    MerchandiseCellView(merchandise: merchandise)
                    Divider()
                }
            } header: {
                Text("Safe To Eat")
                    .font(.system(size: 22).weight(.heavy))
            }
        }
    }
    
    var stockView: some View {
        VStack(alignment: .leading) {
            Section {
                ForEach(pantryModel.merchandise) { merchandise in
                    MerchandiseCellView(merchandise: merchandise)
                    Divider()
                }
            } header: {
                Text("Stock")
                    .font(.system(size: 22).weight(.heavy))
            }
        }
    }
    
    var expiredMerchandise: some View {
        VStack(alignment: .leading) {
            Section {
                VStack {
                    ForEach(pantryModel.merchandise.expired()) { merchandise in
                        MerchandiseCellView(merchandise: merchandise)
                        Divider()
                    }
                }
            } header: {
                Text("Expired")
                    .font(.system(size: 22).weight(.heavy))
            }
        }
    }
    
    var expiringMerchandise: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Section {
                    VStack {
                        ForEach(pantryModel.merchandise.expiresSoon()) { merchandise in
                            MerchandiseCellView(merchandise: merchandise)
                            Divider()
                        }
                    }
                } header: {
                    Text("Expires Soon")
                        .font(.system(size: 22).weight(.heavy))
                }
            }
        }
    }
}

@available(iOS 16.0, *)
fileprivate struct MerchandiseCellView: View {
    
    @State private var isShowingMerchandiseDetailView = false
    
    let merchandise: Merchandise
    
    @EnvironmentObject var pantryModel: PantryViewModel
    
    var body: some View {
        HStack {
            Text(merchandise.emoji)
                .font(.system(size: 35))
            VStack(alignment: .leading) {
                Text(merchandise.name)
                    .font(.system(size: 16).weight(.heavy))
                Text(merchandise.type.rawValue)
                    .font(.system(size: 14))
                HStack {
                    if !(merchandise.isExpired || merchandise.isExpiringSoon) {
                        merchandise.daysToExpirationLabel
                    }
                    else if merchandise.isExpiringSoon {
                        merchandise.expiringLabel
                    } else if merchandise.isExpired {
                        merchandise.expiredLabel
                    }
                    if (merchandise.isLowOnStock || merchandise.isOutOfStock) {
                        Text("|")
                    }
                    if merchandise.isLowOnStock {
                        merchandise.lowStockLabel
                    } else if merchandise.isOutOfStock {
                        merchandise.isOutOfStockLabel
                    }
                }
                .font(.system(size: 15).weight(.medium))
            }
            Spacer()
            Button {
                isShowingMerchandiseDetailView.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            }
        }
        .padding(.top)
        .accentColor(.appPrimary)
        .sheet(isPresented: $isShowingMerchandiseDetailView) {
            SelectedMerchandiseDetailView(merchandise: merchandise)
                .preferredColorScheme(.light)
        }
    }
}

@available(iOS 16.0, *)
struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
//        MerchandiseCellView(merchandise: .init(name: "Brocoli", emoji: "", type: .vegetables, expirationDate: Date.now.addingTimeInterval(86400*1)))
        PantryView()
            .environmentObject(PantryViewModel())
    }
}
