//
//  Meal.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// Meal object model
struct Meal: Codable, Hashable {
    var id: Int
    var name: String
    var created_at: String
    var updated_at: String
}
