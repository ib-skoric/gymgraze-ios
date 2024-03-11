//
//  Goal.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// Goal object model
struct Goal: Codable {
    var kcal: Int
    var steps: Int
    var exercise: Int
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case kcal
        case steps
        case exercise
        case updatedAt = "updated_at"
    }
}

struct GoalPayload: Codable {
    var kcal: Int
    var steps: Int
    var exercise: Int
}
