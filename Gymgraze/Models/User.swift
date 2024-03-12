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
    var confirmedAt: Date? = nil
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        weight = try container.decodeIfPresent(String.self, forKey: .weight)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        goal = try container.decodeIfPresent(Goal.self, forKey: .goal)
        meals = try container.decodeIfPresent([Meal].self, forKey: .meals)
        
        if let confirmedAtTimestamp = try container.decodeIfPresent(Double.self, forKey: .confirmedAt) {
            confirmedAt = Date(timeIntervalSince1970: confirmedAtTimestamp)
        }
    }
}
