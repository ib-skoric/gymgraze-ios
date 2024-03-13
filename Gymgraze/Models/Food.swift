//
//  Food.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// Food object model
struct Food: Codable {
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
