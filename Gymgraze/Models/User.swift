//
//  User.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// User object model
struct User: Codable {
    var id: Int?
    var email: String?
    var name: String?
    var age: Int?
    var weight: String?
    var height: Int?
    var confirmedAt: String? = nil
    var goal: Goal?
    var meals: [Meal]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case age
        case weight
        case height
        case confirmedAt = "confirmed_at"
        case goal
        case meals
    }
}
