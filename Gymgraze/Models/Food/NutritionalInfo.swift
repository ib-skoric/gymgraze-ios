//
//  NutritionalInfo.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// NutritionalInfo object model
struct NutritionalInfo: Codable {
    var id: Int?
    var kcal: Int
    var carbs: Double
    var protein: Double
    var fat: Double
    var salt: Double
    var sugar: Double
    var fiber: Double
    
    init() {
        self.id = nil
        self.kcal = 0
        self.carbs = 0
        self.protein = 0
        self.fat = 0
        self.salt = 0
        self.sugar = 0
        self.fiber = 0
    }
    
    init(kcal: Int, carbs: Double, protein: Double, fat: Double, salt: Double, sugar: Double, fiber: Double) {
        self.id = nil
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fat = fat
        self.salt = salt
        self.sugar = sugar
        self.fiber = fiber
    }
    
    init(from nutriments: FoodItem.Nutriments) {
        self.kcal = nutriments.kcal100g ?? 0
        self.carbs = nutriments.carbs100g ?? 0.0
        self.protein = nutriments.protein100g ?? 0.0
        self.fat = nutriments.fat100g ?? 0.0
        self.salt = nutriments.salt100g ?? 0.0
        self.sugar = nutriments.sugar100g ?? 0.0
        self.fiber = nutriments.fiber100g ?? 0.0
    }
}
