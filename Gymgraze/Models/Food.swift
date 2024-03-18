//
//  Food.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// Food object model
struct Food: Codable, Identifiable {
    var id: Int
    var barcode: Int
    var name: String
    var nutritionalInfo: NutritionalInfo
    var meal: Meal
    
    enum CodingKeys: String, CodingKey {
        case id
        case barcode
        case name
        case nutritionalInfo = "nutritional_info"
        case meal
    }
}

struct FoodItem: Codable, Identifiable {
    var id: String
    var product: Product
    
    struct Product: Codable {
        var nutriments: Nutriments
    }
    
    struct Nutriments: Codable {
        var kcal100g: Int
        var carbs100g: Double
        var protein100g: Double
        var fat100g: Double
        var salt100g: Double
        var sugar100g: Double
        var fiber100g: Double
        
        enum CodingKeys: String, CodingKey {
            case kcal100g = "energy-kcal_100g"
            case carbs100g = "carbohydrates_100g"
            case protein100g = "proteins_100g"
            case fat100g = "fat_100g"
            case salt100g = "salt_100g"
            case sugar100g = "sugars_100g"
            case fiber100g = "fiber_100g"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case product
    }
    
    init(id: String, product: Product) {
        self.id = id
        self.product = product
    }
    
    init() {
        id = ""
        product = Product(nutriments: Nutriments(kcal100g: 0, carbs100g: 0, protein100g: 0, fat100g: 0, salt100g: 0, sugar100g: 0, fiber100g: 0))
    }
}
