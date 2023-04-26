//
//  SwiftUIView.swift
//  
//
//  Created by Jaylen Smith on 4/18/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct ScannedProductView: View {
    
    @State private var id: UUID?
    
    @State private var isAlreadySaved = false
    
    @State private var name: String = ""
    @State private var upc: String = ""
    @State private var emoji = ""
    @State private var type: MerchandiseType = .vegetables
    @State private var price: Double = 0
    @State private var quantity = 1
    @State private var expirationDate: Date = .now.addingTimeInterval(86400*5)
    
    let scanType: ScannedItemType
    
    @State private var isShowingEmojiView = false
            
    @EnvironmentObject var pantryModel: PantryViewModel
    
    @Environment (\.dismiss) var dismiss
    @FocusState private var focused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        Spacer()
                            .frame(height: 50)
                        VStack(spacing: 10) {
                            Text(emoji)
                                .font(.system(size: 75))
                             Text("Change Emoji")
                                .font(.system(size: 18).weight(.semibold))
                        }
                        .padding()
                        .onTapGesture {
                            isShowingEmojiView.toggle()
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 50) {
                                VStack(alignment: .leading) {
                                    Section {
                                        customTextField(text: $name, "Product Name")
                                            .keyboardType(.alphabet)
                                            .focused($focused)
                                        customTextField(text: $upc, "Product UPC")
                                            .keyboardType(.numberPad)
                                            .focused($focused)
                                        Spacer()
                                            .frame(height: 15)
                                        VStack {
                                            HStack {
                                                Text("Catergory")
                                                Spacer()
                                                Picker("", selection: $type) {
                                                    ForEach(MerchandiseType.allCases) {
                                                        Text($0.rawValue)
                                                            .tag($0)
                                                    }
                                                }
                                            }
                                            Divider()
                                        }
                                    } header: {
                                        Text("Identity")
                                            .headerStyle()
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Section {
                                        TextField("Price", value: $price, format: .currency(code: "USD"))
                                            .customTextFieldStyle()
                                            .keyboardType(.decimalPad)
                                            .focused($focused)
                                        HStack {
                                            Text("Quantity")
                                            Spacer()
                                            Picker("", selection: $quantity) {
                                                ForEach(0...10, id: \.self) {
                                                    Text("\($0)")
                                                        .tag($0)
                                                }
                                            }
                                        }
                                        .customTextFieldStyle()
                                        DatePicker("Expiration Date", selection: $expirationDate, in: Date.now...Date.now.addingTimeInterval(86400*365), displayedComponents: .date)
                                            .customTextFieldStyle()
                                    } header: {
                                        Text("Additional")
                                            .headerStyle()
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    if !(name.isEmpty) {
                        Button {
                            createMerchandise()
                        } label: {
                            Text(self.isAlreadySaved ? "Update Pantry" : "Add to Pantry")
                                .padding()
                                .frame(width: 350)
                                .font(.system(size: 19).bold())
                                .foregroundColor(.white)
                                .background(Color.appPrimary)
                                .cornerRadius(20)
                                .padding(5)
                        }
                    }
                }
            }
            .autocorrectionDisabled()
            .navigationTitle(scanType.id)
            .toolbarBackground(Color.white, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .bold()
                    }
                }
            }
            .tint(.black)
            .preferredColorScheme(.light)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focused = false
                    }
                }
            }
        }
        .autocorrectionDisabled()
        .submitLabel(.done)
        .onAppear {
            setupDetails()
        }
        .sheet(isPresented: $isShowingEmojiView) {
            EmojiSelectionView(emoji: $emoji, merchandiseType: type)
                .presentationDetents([.height(CGFloat(450))])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: type) { newValue in
            self.emoji = newValue.emoji
        }
    }
    
    private func setupDetails() {
        switch scanType {
        case .manual:
            break
        case .barcode(let upc):
            inputInformation(for: pantryModel.merchandise.hasMerchandiseWithBarcode(upc))
            self.upc = upc
        case .produce(let prediction):
            inputInformation(for: pantryModel.merchandise.hasMerchandiseWithIdentifier(prediction.identifier))
            self.type  = prediction.type
            self.emoji = prediction.type.emoji
            self.name  = prediction.identifier
        case .edit(let id):
            inputInformation(for: pantryModel.merchandise.hasMerchandiseWithID(id))
        }
    }
    
    private func inputInformation(for merchandise: Merchandise?) {
        if let merchandise {
            self.id             = merchandise.id
            self.type           = merchandise.type
            self.name           = merchandise.name
            self.price          = merchandise.price
            self.upc            = merchandise.upc
            self.quantity       = merchandise.quantity
            self.expirationDate = merchandise.expirationDate
            self.emoji          = merchandise.emoji

            self.isAlreadySaved = true
        } else {
            self.emoji = type.emoji
        }
    }
    
    private func createMerchandise() {
        guard !(name.isEmpty) else {
            return
        }
        
        if let id, let removalMerchandise = pantryModel.merchandise.firstIndex(where: {$0.id == id}) {
            pantryModel.merchandise.remove(at: removalMerchandise)
        }
        
        let merchandise = Merchandise(name: self.name,
                                      emoji: self.emoji,
                                      type: self.type,
                                      price: self.price,
                                      upc: self.upc,
                                      quantity: quantity,
                                      expirationDate: self.expirationDate)
        pantryModel.addMerchandise(merchandise)
        dismiss()
    }
}

private extension View {
    func customTextField(text: Binding<String>, _ title: String) -> some View {
        return VStack {
            TextField(title, text: text)
                .padding(.top)
            Divider()
        }
    }
    
    func customTextFieldStyle() -> some View {
        return VStack {
            self
                .padding(.top)
            Divider()
        }
    }
}

private extension Text {
    
    func headerStyle() -> some View {
        return self
            .font(.system(size: 30).weight(.heavy))
    }
}

@available(iOS 16.0, *)
struct ScanProductBarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        ScannedProductView(scanType: .produce(.apple))
            .environmentObject(PantryViewModel())
    }
}
