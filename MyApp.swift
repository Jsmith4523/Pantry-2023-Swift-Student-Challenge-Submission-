import SwiftUI

@available(iOS 16.0, *)
@main
struct MyApp: App {
    
    @StateObject private var pantryModel = PantryViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch pantryModel.didOnboard {
                case true:
                    ScannerView()
                case false:
                    PantryOnboarding()
                }
            }
            .tint(.appPrimary)
            .environmentObject(pantryModel)
        }
    }
}
