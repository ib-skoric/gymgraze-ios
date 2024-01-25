//
//  NutritionalInfo.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

struct NutritionalInfo: Codable {
    var id: String
    var kcal: Int
    var carbs: Double
    var protein: Double
    var fat: Double
}
