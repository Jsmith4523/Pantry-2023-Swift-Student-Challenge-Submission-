//
//  Merchandise.swift
//  Pantry
//
//  Created by Jaylen Smith on 4/12/23.
//

import Foundation
import SwiftUI

enum MerchandiseType: String, CaseIterable, Identifiable, Comparable, Codable {
    var id: String {
        self.rawValue
    }
    
    case fruit      = "Fruit"
    case eggs       = "Eggs"
    case vegetables = "Vegetables"
    case dessert    = "Dessert"
    case iceCream   = "Ice Cream"
    case canned     = "Canned Food"
    case condiment  = "Condiment"
    case cleaning   = "Cleaning Supplies"
    case snack      = "Snack"
    case milk       = "Milk"
    case juice      = "Juice"
    case cereal     = "Cereal"
    case meat       = "Meat"
    case frozenFood = "Frozen Food"
    
    /// Default emoji
    var emoji: String {
        switch self {
        case .fruit:
            return "🍎"
        case .vegetables:
            return "🥦"
        case .dessert:
            return "🧁"
        case .iceCream:
            return "🍦"
        case .canned:
            return "🥫"
        case .cleaning:
            return "🧼"
        case .condiment:
            return "🧈"
        case .snack:
            return "🍿"
        case .milk:
            return "🥛"
        case .juice:
            return "🧃"
        case .cereal:
            return "🥣"
        case .meat:
            return "🥩"
        case .frozenFood:
            return "🧊"
        case .eggs:
            return "🥚"
        }
    }
    
    var emojis: [String] {
        switch self {
        case .fruit:
            return ["🍒", "🍓", "🍑", "🥥", "🍇", "🍎", "🥑", "🍊", "🍋", "🥝", "🍌", "🍉", "🍐", "🫐", "🥭"]
        case .vegetables:
            return ["🌶️", "🥕", "🧅", "🥒", "🌽", "🍅", "🥦", "🧄", "🍆", "🥔", "🫑"]
        case .dessert:
            return ["🎂", "🍰", "🧁", "🥧", "🥮"]
        case .iceCream:
            return ["🍦", "🍨"]
        case .canned:
            return ["🥫"]
        case .condiment:
            return ["🧈"]
        case .cleaning:
            return ["🧻", "🧼", "🧽"]
        case .snack:
            return ["🍟", "🍿", "🥨", "🍪", "🍭", "🍩", "🍬"]
        case .milk:
            return ["🥛", "🍼"]
        case .juice:
            return ["🧃"]
        case .cereal:
            return ["🥣"]
        case .meat:
            return ["🍗", "🥓", "🥩", "🍖"]
        case .frozenFood:
            return ["🧊"]
        case .eggs:
            return ["🥚"]
        }
    }
    
    static func < (lhs: MerchandiseType, rhs: MerchandiseType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    static func > (lhs: MerchandiseType, rhs: MerchandiseType) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
}

struct Merchandise: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let emoji: String
    let type: MerchandiseType
    var price: Double
    var upc: String
    var quantity: Int = 1
    var expirationDate: Date
}

extension Merchandise {
    
    private var expirationDays: Int? {
        return Int(expirationDate.distanceDaysToExpired)
    }
    
    var isExpiringSoon: Bool {
        let userExpirationDays = UserDefaults.standard.integer(forKey: "expirationDays")
        
        //TODO: User defaults
        guard let expirationDays, expirationDays <= userExpirationDays, expirationDays >= 0 else {
            return false
        }
        
        return true
    }
    
    var isExpired: Bool {
        guard let expirationDays, expirationDays <= 0 else {
            return false
        }
        
        return true
    }
    
    var isOutOfStock: Bool {
        //Stock doesn't matter once the item has expired
        self.quantity <= 0 && !(isExpired)
    }
    
    var isLowOnStock: Bool {
        self.quantity <= 4 && self.quantity >= 1 && !(isExpired)
    }
    
    var daysToExpired: String  {
        return "\(expirationDate.distanceDaysToExpired == 0 ? "Expires Today" : expirationDate.distanceDaysToExpired == 1 ? "Expires Tomorrow" : "Expires in \(expirationDate.distanceDaysToExpired) days")"
    }
    
    var isOutOfStockLabel: some View {
        Text("Out of Stock")
            .foregroundColor(.red)
    }
    
    var lowStockLabel: some View {
        Text("Low Stock")
            .foregroundColor(.appPrimary)
    }
    
    var daysToExpirationLabel: some View {
        Text(daysToExpired)
            .italic()
            .foregroundColor(.gray)
    }
    
    var expiredLabel: some View {
        Text("Expired")
            .foregroundColor(.red)
    }
    
    var expiringLabel: some View {
        Text("\(daysToExpired)")
            .foregroundColor(.appPrimary)
    }
}

extension Set<Merchandise> {
    
}

extension [Merchandise] {
    
    func hasMerchandiseWithBarcode(_ upc: String) -> Merchandise? {
        for merchandise in self {
            if merchandise.upc == upc {
                return merchandise
            }
        }
        return nil
    }
    
    func hasMerchandiseWithID(_ id: UUID) -> Merchandise? {
        for merchandise in self {
            if merchandise.id == id {
                return merchandise
            }
        }
        return nil
    }
    
    func hasMerchandiseWithIdentifier(_ identifier: String) -> Merchandise? {
        for merchandise in self {
            if merchandise.name == identifier {
                return merchandise
            }
        }
        return nil
    }
    
    func hasExpiredMerchandise() -> Bool {
        !(self.expired().isEmpty)
    }
    
    func hasExpiringMerchandise() -> Bool {
        !(self.expiresSoon().isEmpty)
    }
    
    func hasSafeToEatMerchandise() -> Bool {
        !(self.canEat().isEmpty)
    }
    
    func expired() -> [Merchandise] {
        self.filter({$0.isExpired == true})
    }
    
    func expiresSoon() -> [Merchandise] {
        self.filter({$0.isExpiringSoon == true})
    }
    
    func canEat() -> [Merchandise] {
        self.filter({!($0.isExpired || $0.type == .cleaning)})
    }
}
