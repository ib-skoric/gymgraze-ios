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
    var kcal: String?
    var carbs: Double?
    var protein: Double?
    var fat: Double?
}
