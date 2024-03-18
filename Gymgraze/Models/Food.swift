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
    var name: String
    var nutritionalInfo: NutritionalInfo
    var meal: Meal
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nutritionalInfo = "nutritional_info"
        case meal
    }
}

struct FoodItem: Codable, Identifiable {
    var id: String?
    var barcode: String
    var nutriments: Nutriments
    
    struct Nutriments: Codable {
        var kcal100g: Int
        var carbs100g: Double
        var protein100g: Double
        var fat100g: Double
        var salt100g: Double
        var sugar100g: Double
        var fiber100g: Double
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case barcode = "code"
        case nutriments
    }
    
    init(id: String?, barcode: String, nutriments: Nutriments) {
        self.id = barcode
        self.barcode = barcode
        self.nutriments = nutriments
    }
}
