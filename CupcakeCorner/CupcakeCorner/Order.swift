//
//  Order.swift
//  CupcakeCorner
//
//  Created by Mac on 29/08/2024.
//

import Foundation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
//    var type = 0
//    var quantity = 3
//    
//    var specialRequestEnabled = false {
//        didSet {
//            if specialRequestEnabled == false {
//                extraFrosting = false
//                addSprinkles = false
//            }
//        }
//    }
//    var extraFrosting = false
//    var addSprinkles = false
//    
//    var name = ""
//    var streetAddress = ""
//    var city = ""
//    var zip = ""
    
    init() {
            loadFromUserDefaults()
        }
        
        var type = 0 {
            didSet { saveToUserDefaults() }
        }
        var quantity = 3 {
            didSet { saveToUserDefaults() }
        }
        var specialRequestEnabled = false {
            didSet {
                if specialRequestEnabled == false {
                    extraFrosting = false
                    addSprinkles = false
                }
                saveToUserDefaults()
            }
        }
        var extraFrosting = false {
            didSet { saveToUserDefaults() }
        }
        var addSprinkles = false {
            didSet { saveToUserDefaults() }
        }
        
        var name = "" {
            didSet { saveToUserDefaults() }
        }
        var streetAddress = "" {
            didSet { saveToUserDefaults() }
        }
        var city = "" {
            didSet { saveToUserDefaults() }
        }
        var zip = "" {
            didSet { saveToUserDefaults() }
        }
    
//    var hasValidAddress: Bool {
//        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
//            return false
//        }
//        
//        return true
//    }
    
    var hasValidAddress: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStreetAddress = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedZip = zip.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty || trimmedStreetAddress.isEmpty || trimmedCity.isEmpty || trimmedZip.isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake fpr extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    private func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(type, forKey: "type")
        defaults.set(quantity, forKey: "quantity")
        defaults.set(specialRequestEnabled, forKey: "specialRequestEnabled")
        defaults.set(extraFrosting, forKey: "extraFrosting")
        defaults.set(addSprinkles, forKey: "addSprinkles")
        defaults.set(name, forKey: "name")
        defaults.set(streetAddress, forKey: "streetAddress")
        defaults.set(city, forKey: "city")
        defaults.set(zip, forKey: "zip")
    }
    
    private func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        type = defaults.integer(forKey: "type")
        quantity = defaults.integer(forKey: "quantity")
        specialRequestEnabled = defaults.bool(forKey: "specialRequestEnabled")
        extraFrosting = defaults.bool(forKey: "extraFrosting")
        addSprinkles = defaults.bool(forKey: "addSprinkles")
        name = defaults.string(forKey: "name") ?? ""
        streetAddress = defaults.string(forKey: "streetAddress") ?? ""
        city = defaults.string(forKey: "city") ?? ""
        zip = defaults.string(forKey: "zip") ?? ""
    }
}
