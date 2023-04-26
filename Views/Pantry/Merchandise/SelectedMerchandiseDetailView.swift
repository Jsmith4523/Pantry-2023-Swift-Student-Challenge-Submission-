//
//  SwiftUIView.swift
//  
//
//  Created by Jaylen Smith on 4/18/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct SelectedMerchandiseDetailView: View {
    
    @State private var isShowingMerchandiseView = false
    
    @State private var alertThrowAway = false
    
    let merchandise: Merchandise
    
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var pantryModel: PantryViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: 25)
                    Text(merchandise.emoji)
                        .font(.system(size: 150))
                    Spacer()
                        .frame(height: 15)
                    VStack(spacing: 2) {
                        if merchandise.isLowOnStock {
                            merchandise.lowStockLabel
                                .font(.system(size: 25).bold())
                        } else if merchandise.isOutOfStock {
                            merchandise.isOutOfStockLabel
                                .font(.system(size: 25).bold())
                        } else {
                            if merchandise.isExpired {
                                merchandise.expiredLabel
                                    .font(.system(size: 25).bold())
                            } else if merchandise.isExpiringSoon {
                                merchandise.expiringLabel
                                    .font(.system(size: 25).bold())
                                    .foregroundColor(.appPrimary)
                            }
                        }
                        Text(merchandise.name)
                            .font(.system(size: 45).weight(.heavy))
                        Text(merchandise.type.rawValue)
                            .font(.system(size: 22).weight(.medium))
                    }
                    Spacer()
                        .frame(height: 50)
                    Divider()
                    if merchandise.isExpired {
                        throwawayButton
                    } else {
                        merchandiseInformation
                    }
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .bold()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        self.isShowingMerchandiseView.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .bold()
                    }
                    Button {
                        throwAwayMerchandise()
                    } label: {
                        Image(systemName: "trash")
                            .bold()
                    }
                }
            }
            .alert("Throw away?", isPresented: $alertThrowAway) {
                Button("No!") {}
                Button("Yes") {
                    pantryModel.throwAwayMerchandise(merchandise)
                }
            } message: {
                Text("This item still appears to be fresh. Are you sure you want to throw it away?")
            }
            .tint(.black)
            .accentColor(.black)
            .sheet(isPresented: $isShowingMerchandiseView) {
                ScannedProductView(scanType: .edit(merchandise.id))
            }
        }
    }
    
    var merchandiseInformation: some View {
        HStack {
            VStack(alignment: .leading) {
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Spacer()
                            .frame(height: 2)
                        Text("UPC: \(merchandise.upc)")
                        Text("Expiration Date: \(merchandise.expirationDate.fullDate)")
                        if !(merchandise.price == 0) {
                            Text("Price Per: ")+Text(merchandise.price, format: .currency(code: "USD"))
                        }
                        Text("Quantity: \(merchandise.quantity)")
                    }
                    .font(.system(size: 19))
                } header: {
                    Text("Details")
                        .font(.system(size: 30).weight(.heavy))
                }
            }
            Spacer()
        }
        .padding(5)
    }
    
    var throwawayButton: some View {
        VStack {
            Spacer()
                .frame(height: 100)
            Button {
                throwAwayMerchandise()
            } label: {
                Text("Throw Away")
                    .padding()
                    .frame(width: 300)
                    .font(.system(size: 19).bold())
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(30)
            }
            Spacer()
        }
    }
    
    func throwAwayMerchandise() {
        if merchandise.isExpired && !(merchandise.isOutOfStock) {
            pantryModel.throwAwayMerchandise(merchandise)
        } else {
            alertThrowAway.toggle()
        }
    }
}

//@available(iOS 16.0, *)
//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedMerchandiseDetailView(merchandise: .init(name: "Tomatos", emoji: "🍅", type: .vegetables, price: 35.45, quantity: 10, expirationDate: .now.addingTimeInterval(86400*10)))
//            .environmentObject(PantryViewModel())
//    }
//}
