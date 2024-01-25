//
//  Meal.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

struct Meal: Codable {
    var id: Int
    var name: String
    var createdAt: Date
    var updatedAt: Date
    var nutritionalInfo: NutritionalInfo
}
