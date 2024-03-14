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
}
