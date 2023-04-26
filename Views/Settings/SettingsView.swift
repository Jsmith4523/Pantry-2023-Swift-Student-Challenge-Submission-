//
//  SwiftUIView.swift
//  
//
//  Created by Jaylen Smith on 4/19/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct SettingsView: View {
    
    @EnvironmentObject var pantryModel: PantryViewModel
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 25)
                HStack {
                    Text("Expiration Alert")
                    Spacer()
                    Picker("", selection: $pantryModel.expirationDays) {
                        ForEach(3...9, id: \.self) {
                            Text("\($0) Days Before")
                                .tag($0)
                        }
                    }
                }
                .font(.system(size: 19).bold())
                Divider()
                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
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
            .preferredColorScheme(.light)
            .accentColor(.black)
            .interactiveDismissDisabled()
        }
    }
}

@available(iOS 16.0, *)
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(PantryViewModel())
    }
}
