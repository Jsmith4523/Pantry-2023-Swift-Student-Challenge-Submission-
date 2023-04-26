//
//  SwiftUIView.swift
//  
//
//  Created by Jaylen Smith on 4/18/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct EmojiSelectionView: View {
    
    @State private var columns = [GridItem(), GridItem(), GridItem()]
    
    @Binding var emoji: String
    let merchandiseType: MerchandiseType
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(merchandiseType.emojis, id: \.self) { emoji in
                        VStack {
                            Text(emoji)
                                .font(.system(size: 45))
                            Spacer()
                            if emoji == self.emoji {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                        }
                        .frame(height: 75)
                        .padding()
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .heavy).prepare()
                            dismiss()
                            self.emoji = emoji
                        }
                    }
                }
            }
            .navigationTitle("Select Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.light)
        }
    }
}

@available(iOS 16.0, *)
struct EmojiSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiSelectionView(emoji: .constant("🍎"), merchandiseType: .fruit)
    }
}
