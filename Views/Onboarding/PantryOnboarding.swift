//
//  SwiftUIView.swift
//  
//
//  Created by Jaylen Smith on 4/16/23.
//

import SwiftUI

private enum OnboardingPosition {
    case welcome, explain, intelligence, jumpIn
    
}

struct PantryOnboarding: View {
    
    @State private var position: OnboardingPosition = .welcome
    
    @EnvironmentObject var pantryModel: PantryViewModel
    
    func changePosition() {
        withAnimation {
            if position == .welcome {
                self.position = .explain
            } else if position == .explain {
                self.position = .intelligence
            } else if position == .intelligence {
                self.position = .jumpIn
            } else if position == .jumpIn {
                //Leave onboarding...
                withAnimation {
                    pantryModel.didOnboard = true
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appPrimary.ignoresSafeArea()
                VStack {
                    TabView(selection: $position) {
                        welcome
                            .tag(OnboardingPosition.welcome)
                        howItWorks
                            .tag(OnboardingPosition.explain)
                        intelligence
                            .tag(OnboardingPosition.intelligence)
                        jumpIn
                            .tag(OnboardingPosition.jumpIn)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    //Disabling swipe
                    .disabled(true)
                    
                    Button {
                        changePosition()
                    } label: {
                        Text(position == .jumpIn ? "Jump In!" : "Next")
                            .padding()
                            .frame(width: 300)
                            .background(Color.white)
                            .font(.system(size: 20).bold())
                            .foregroundColor(.appPrimary)
                            .cornerRadius(30)
                            .padding()
                    }
                    Spacer()
                }
            }
        }
        .statusBarHidden(true)
        .foregroundColor(.white)
        .tint(.white)
    }
    
    var welcome: some View {
        VStack(spacing: 16) {
            Text("🥪")
                .font(.system(size: 100))
            Text("Welcome To Pantry")
                .font(.system(size: 30).bold())
            Text("An easier way to reduce food waste, save money, and manage merchandise!")
                .font(.system(size: 18))
        }
        .multilineTextAlignment(.center)
        .padding()
    }
    
    var howItWorks: some View {
        VStack(spacing: 16) {
            Image(systemName: "iphone.rear.camera")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("How it works...")
                .font(.system(size: 30).bold())
            Text("Pantry uses your on-device camera to scan barcodes of inventory within your kitchen. Just as if you had your own supermarket inventory system within the palm of your hand!")
                .font(.system(size: 18))

        }
        .padding()
        .multilineTextAlignment(.center)
    }
    
    var intelligence: some View {
        ZStack {
            Color.appPrimary.ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "brain")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("It's intelligent!")
                    .font(.system(size: 30).bold())
                Text("Pantry's uses on-device machine learning that can automatically detect most fruits and vegetables such as Apples, Oranges, Tomatoes, and more! Once it detects an item, you can easily add it pantry!")
            }
            .multilineTextAlignment(.center)
            .padding()
        }
    }
    
    var jumpIn: some View {
        VStack(spacing: 16) {
            Text("🍔")
                .font(.system(size: 60))
            Text("And that's it!")
                .font(.system(size: 30).bold())
            Text("Now you're ready for an easier way to manage inventory within your home while reducing food waste and saving money. Press 'Jump In!' to get started")
                .font(.system(size: 18))
        }
        .padding()
        .multilineTextAlignment(.center)
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        PantryOnboarding()
            .environmentObject(PantryViewModel())
    }
}
